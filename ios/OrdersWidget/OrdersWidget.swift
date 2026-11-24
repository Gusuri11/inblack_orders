import SwiftUI
import WidgetKit

private let appGroup = "group.com.inblack.orders"

struct WidgetOrder: Decodable, Hashable {
  let id: String
  let name: String
  let status: String
  let amount: String
}

struct OrdersEntry: TimelineEntry {
  let date: Date
  let signedIn: Bool
  let title: String
  let openCount: String
  let orders: [WidgetOrder]
}

struct OrdersProvider: TimelineProvider {
  func placeholder(in context: Context) -> OrdersEntry {
    OrdersEntry(date: .now, signedIn: true, title: "Open orders", openCount: "3", orders: [])
  }

  func getSnapshot(in context: Context, completion: @escaping (OrdersEntry) -> Void) {
    completion(load())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<OrdersEntry>) -> Void) {
    completion(Timeline(entries: [load()], policy: .never))
  }

  private func load() -> OrdersEntry {
    let defaults = UserDefaults(suiteName: appGroup)
    let signedIn = defaults?.string(forKey: "signed_in") == "true"
    let json = defaults?.string(forKey: "items") ?? "[]"
    let orders = (try? JSONDecoder().decode([WidgetOrder].self, from: Data(json.utf8))) ?? []
    return OrdersEntry(
      date: .now,
      signedIn: signedIn,
      title: defaults?.string(forKey: "title") ?? "",
      openCount: defaults?.string(forKey: "open_count") ?? "0",
      orders: signedIn ? orders : []
    )
  }
}

struct OrdersWidgetView: View {
  let entry: OrdersEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Link(destination: URL(string: "inblack://orders?status=PENDING,PAID,IN_PROGRESS")!) {
        HStack {
          Text(entry.signedIn ? entry.title : "InBlack Orders")
            .font(.headline)
          Spacer()
          Text(entry.signedIn ? entry.openCount : "–")
            .font(.title.bold())
            .accessibilityLabel("\(entry.title) \(entry.openCount)")
        }
      }
      ForEach(entry.orders.prefix(3), id: \.self) { order in
        Link(destination: URL(string: "inblack://orders/\(order.id)")!) {
          VStack(alignment: .leading, spacing: 2) {
            Text("\(order.id) · \(order.name)").font(.caption).lineLimit(1)
            Text("\(order.status) · \(order.amount)")
              .font(.caption2)
              .foregroundStyle(.secondary)
              .lineLimit(1)
          }
        }
      }
      Spacer(minLength: 0)
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }
}

@main
struct OrdersWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "OrdersWidget", provider: OrdersProvider()) { entry in
      OrdersWidgetView(entry: entry)
    }
    .configurationDisplayName("InBlack Orders")
    .description("Open orders and the latest three")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}
