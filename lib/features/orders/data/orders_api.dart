import 'package:dio/dio.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';

class DetailFetch {
  const DetailFetch({this.detail, this.etag, this.notModified = false});

  final OrderDetail? detail;
  final String? etag;
  final bool notModified;
}

class OrdersApi {
  OrdersApi(this._dio);

  final Dio _dio;

  Future<OrdersPage> getOrders({
    int limit = 50,
    String? cursor,
    List<String> statuses = const [],
    String? query,
  }) async {
    final json = await _get('/orders', {
      'limit': limit,
      'cursor': ?cursor,
      if (statuses.isNotEmpty) 'status': statuses.join(','),
      if (query != null && query.isNotEmpty) 'q': query,
    });
    return OrdersPage.fromJson(json);
  }

  Future<OrdersSummary> getSummary() async =>
      OrdersSummary.fromJson(await _get('/orders/summary'));

  Future<ChangesPage> getChanges({required int since, int limit = 500}) async {
    final json = await _get('/orders/changes', {
      'since': since,
      'limit': limit,
    });
    return ChangesPage.fromJson(json);
  }

  Future<DetailFetch> getOrder(String id, {String? etag}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/orders/${Uri.encodeComponent(id)}',
        options: Options(
          headers: {'If-None-Match': ?etag},
          validateStatus: (s) => s != null && (s < 300 || s == 304),
        ),
      );
      final newEtag = response.headers.value('etag');
      if (response.statusCode == 304) {
        return DetailFetch(notModified: true, etag: newEtag ?? etag);
      }
      final data = response.data;
      if (data == null) return DetailFetch(notModified: true, etag: etag);
      return DetailFetch(detail: OrderDetail.fromJson(data), etag: newEtag);
    } on DioException catch (e) {
      throw toApiException(e);
    }
  }

  Future<Map<String, dynamic>> _get(
    String path, [
    Map<String, dynamic>? query,
  ]) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return response.data ?? const {};
    } on DioException catch (e) {
      throw toApiException(e);
    }
  }
}
