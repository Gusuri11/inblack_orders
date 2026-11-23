part of 'order_models.dart';

_PrimaryItem _$PrimaryItemFromJson(Map<String, dynamic> json) => _PrimaryItem(
  sku: json['sku'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$PrimaryItemToJson(_PrimaryItem instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };

_OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) =>
    _OrderSummary(
      id: json['id'] as String,
      status: json['status'] as String,
      version: (json['version'] as num).toInt(),
      totalMinor: (json['totalMinor'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currency: json['currency'] as String? ?? 'THB',
      lineCount: (json['lineCount'] as num?)?.toInt() ?? 0,
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      primaryItem: json['primaryItem'] == null
          ? null
          : PrimaryItem.fromJson(json['primaryItem'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderSummaryToJson(_OrderSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'version': instance.version,
      'totalMinor': instance.totalMinor,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'currency': instance.currency,
      'lineCount': instance.lineCount,
      'itemCount': instance.itemCount,
      'primaryItem': instance.primaryItem,
    };

_OrderLine _$OrderLineFromJson(Map<String, dynamic> json) => _OrderLine(
  sku: json['sku'] as String,
  name: json['name'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitPriceMinor: (json['unitPriceMinor'] as num).toInt(),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$OrderLineToJson(_OrderLine instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'name': instance.name,
      'quantity': instance.quantity,
      'unitPriceMinor': instance.unitPriceMinor,
      'imageUrl': instance.imageUrl,
    };

_OrderHistoryEntry _$OrderHistoryEntryFromJson(Map<String, dynamic> json) =>
    _OrderHistoryEntry(
      status: json['status'] as String,
      at: DateTime.parse(json['at'] as String),
      by: json['by'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$OrderHistoryEntryToJson(_OrderHistoryEntry instance) =>
    <String, dynamic>{
      'status': instance.status,
      'at': instance.at.toIso8601String(),
      'by': instance.by,
      'note': instance.note,
    };

_OrderNote _$OrderNoteFromJson(Map<String, dynamic> json) => _OrderNote(
  id: json['id'] as String,
  text: json['text'] as String,
  author: json['author'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrderNoteToJson(_OrderNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'author': instance.author,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_OrderAttachment _$OrderAttachmentFromJson(Map<String, dynamic> json) =>
    _OrderAttachment(
      id: json['id'] as String,
      contentType: json['contentType'] as String,
      size: (json['size'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OrderAttachmentToJson(_OrderAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentType': instance.contentType,
      'size': instance.size,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => _OrderDetail(
  id: json['id'] as String,
  status: json['status'] as String,
  version: (json['version'] as num).toInt(),
  totalMinor: (json['totalMinor'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  currency: json['currency'] as String? ?? 'THB',
  lineCount: (json['lineCount'] as num?)?.toInt() ?? 0,
  itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
  primaryItem: json['primaryItem'] == null
      ? null
      : PrimaryItem.fromJson(json['primaryItem'] as Map<String, dynamic>),
  playerId: json['playerId'] as String?,
  channel: json['channel'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderLine>[],
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => OrderHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderHistoryEntry>[],
  notes:
      (json['notes'] as List<dynamic>?)
          ?.map((e) => OrderNote.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderNote>[],
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => OrderAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderAttachment>[],
);

Map<String, dynamic> _$OrderDetailToJson(_OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'version': instance.version,
      'totalMinor': instance.totalMinor,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'currency': instance.currency,
      'lineCount': instance.lineCount,
      'itemCount': instance.itemCount,
      'primaryItem': instance.primaryItem,
      'playerId': instance.playerId,
      'channel': instance.channel,
      'items': instance.items,
      'history': instance.history,
      'notes': instance.notes,
      'attachments': instance.attachments,
    };

_OrdersPage _$OrdersPageFromJson(Map<String, dynamic> json) => _OrdersPage(
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  syncSeq: (json['syncSeq'] as num).toInt(),
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$OrdersPageToJson(_OrdersPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'syncSeq': instance.syncSeq,
      'nextCursor': instance.nextCursor,
    };

_OrderChange _$OrderChangeFromJson(Map<String, dynamic> json) => _OrderChange(
  seq: (json['seq'] as num).toInt(),
  type: json['type'] as String,
  order: json['order'] == null
      ? null
      : OrderSummary.fromJson(json['order'] as Map<String, dynamic>),
  id: json['id'] as String?,
);

Map<String, dynamic> _$OrderChangeToJson(_OrderChange instance) =>
    <String, dynamic>{
      'seq': instance.seq,
      'type': instance.type,
      'order': instance.order,
      'id': instance.id,
    };

_ChangesPage _$ChangesPageFromJson(Map<String, dynamic> json) => _ChangesPage(
  changes: (json['changes'] as List<dynamic>)
      .map((e) => OrderChange.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextSince: (json['nextSince'] as num).toInt(),
  hasMore: json['hasMore'] as bool,
  syncSeq: (json['syncSeq'] as num).toInt(),
);

Map<String, dynamic> _$ChangesPageToJson(_ChangesPage instance) =>
    <String, dynamic>{
      'changes': instance.changes,
      'nextSince': instance.nextSince,
      'hasMore': instance.hasMore,
      'syncSeq': instance.syncSeq,
    };

_OrdersSummary _$OrdersSummaryFromJson(Map<String, dynamic> json) =>
    _OrdersSummary(
      counts: Map<String, int>.from(json['counts'] as Map),
      total: (json['total'] as num).toInt(),
      syncSeq: (json['syncSeq'] as num).toInt(),
    );

Map<String, dynamic> _$OrdersSummaryToJson(_OrdersSummary instance) =>
    <String, dynamic>{
      'counts': instance.counts,
      'total': instance.total,
      'syncSeq': instance.syncSeq,
    };
