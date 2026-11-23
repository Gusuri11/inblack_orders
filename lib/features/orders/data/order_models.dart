import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_models.freezed.dart';
part 'order_models.g.dart';

@freezed
abstract class PrimaryItem with _$PrimaryItem {
  const factory PrimaryItem({
    required String sku,
    required String name,
    String? imageUrl,
  }) = _PrimaryItem;

  factory PrimaryItem.fromJson(Map<String, dynamic> json) =>
      _$PrimaryItemFromJson(json);
}

@freezed
abstract class OrderSummary with _$OrderSummary {
  const factory OrderSummary({
    required String id,
    required String status,
    required int version,
    required int totalMinor,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('THB') String currency,
    @Default(0) int lineCount,
    @Default(0) int itemCount,
    PrimaryItem? primaryItem,
  }) = _OrderSummary;

  factory OrderSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryFromJson(json);
}

@freezed
abstract class OrderLine with _$OrderLine {
  const factory OrderLine({
    required String sku,
    required String name,
    required int quantity,
    required int unitPriceMinor,
    String? imageUrl,
  }) = _OrderLine;

  factory OrderLine.fromJson(Map<String, dynamic> json) =>
      _$OrderLineFromJson(json);
}

@freezed
abstract class OrderHistoryEntry with _$OrderHistoryEntry {
  const factory OrderHistoryEntry({
    required String status,
    required DateTime at,
    String? by,
    String? note,
  }) = _OrderHistoryEntry;

  factory OrderHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryEntryFromJson(json);
}

@freezed
abstract class OrderNote with _$OrderNote {
  const factory OrderNote({
    required String id,
    required String text,
    required String author,
    required DateTime createdAt,
  }) = _OrderNote;

  factory OrderNote.fromJson(Map<String, dynamic> json) =>
      _$OrderNoteFromJson(json);
}

@freezed
abstract class OrderAttachment with _$OrderAttachment {
  const factory OrderAttachment({
    required String id,
    required String contentType,
    required int size,
    required DateTime createdAt,
  }) = _OrderAttachment;

  factory OrderAttachment.fromJson(Map<String, dynamic> json) =>
      _$OrderAttachmentFromJson(json);
}

@freezed
abstract class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required String id,
    required String status,
    required int version,
    required int totalMinor,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('THB') String currency,
    @Default(0) int lineCount,
    @Default(0) int itemCount,
    PrimaryItem? primaryItem,
    String? playerId,
    String? channel,
    @Default(<OrderLine>[]) List<OrderLine> items,
    @Default(<OrderHistoryEntry>[]) List<OrderHistoryEntry> history,
    @Default(<OrderNote>[]) List<OrderNote> notes,
    @Default(<OrderAttachment>[]) List<OrderAttachment> attachments,
  }) = _OrderDetail;

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);
}

@freezed
abstract class OrdersPage with _$OrdersPage {
  const factory OrdersPage({
    required List<OrderSummary> items,
    required int syncSeq,
    String? nextCursor,
  }) = _OrdersPage;

  factory OrdersPage.fromJson(Map<String, dynamic> json) =>
      _$OrdersPageFromJson(json);
}

@freezed
abstract class OrderChange with _$OrderChange {
  const factory OrderChange({
    required int seq,
    required String type,
    OrderSummary? order,
    String? id,
  }) = _OrderChange;

  factory OrderChange.fromJson(Map<String, dynamic> json) =>
      _$OrderChangeFromJson(json);
}

@freezed
abstract class ChangesPage with _$ChangesPage {
  const factory ChangesPage({
    required List<OrderChange> changes,
    required int nextSince,
    required bool hasMore,
    required int syncSeq,
  }) = _ChangesPage;

  factory ChangesPage.fromJson(Map<String, dynamic> json) =>
      _$ChangesPageFromJson(json);
}

@freezed
abstract class OrdersSummary with _$OrdersSummary {
  const factory OrdersSummary({
    required Map<String, int> counts,
    required int total,
    required int syncSeq,
  }) = _OrdersSummary;

  factory OrdersSummary.fromJson(Map<String, dynamic> json) =>
      _$OrdersSummaryFromJson(json);
}
