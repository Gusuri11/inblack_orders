import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/orders_dao.dart';
import 'package:inblack_orders/core/format/formatters.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

abstract interface class WidgetStore {
  Future<void> save(Map<String, String> values);
}

class HomeWidgetStore implements WidgetStore {
  static const androidProvider = 'OrdersWidgetProvider';
  static const iOSKind = 'OrdersWidget';
  static const appGroup = 'group.com.inblack.orders';

  @override
  Future<void> save(Map<String, String> values) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    if (Platform.isIOS) await HomeWidget.setAppGroupId(appGroup);
    for (final e in values.entries) {
      await HomeWidget.saveWidgetData<String>(e.key, e.value);
    }
    await HomeWidget.updateWidget(
      androidName: androidProvider,
      iOSName: iOSKind,
    );
  }
}

class HomeWidgetSync {
  HomeWidgetSync({required this._db, required this._store});

  static const keyTitle = 'title';
  static const keyOpenCount = 'open_count';
  static const keyItems = 'items';
  static const keySignedIn = 'signed_in';

  final AppDatabase _db;
  final WidgetStore _store;

  Future<Map<String, String>> snapshot(AppLocalizations l, String lang) async {
    final open = await _db.ordersDao.countByStatuses(OrderStatuses.open);
    final latest = await _db.ordersDao
        .watchList(const OrderListFilter(), limit: 3)
        .first;
    final items = [
      for (final r in latest)
        {
          'id': r.id,
          'name': r.primaryName ?? l.noProduct,
          'status': OrderStatuses.info(r.status).label(l),
          'amount': Formatters.money(
            r.totalMinor,
            currency: r.currency,
            locale: lang,
          ),
        },
    ];
    return {
      keySignedIn: 'true',
      keyTitle: l.widgetOpenOrders,
      keyOpenCount: '$open',
      keyItems: jsonEncode(items),
    };
  }

  Future<void> push(AppLocalizations l, String lang) async {
    await _store.save(await snapshot(l, lang));
  }

  Future<void> clear() => _store.save({
    keySignedIn: 'false',
    keyTitle: '',
    keyOpenCount: '0',
    keyItems: '[]',
  });
}
