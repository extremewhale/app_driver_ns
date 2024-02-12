import 'package:app_driver_ns/data/models/categoria_site_demo.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';

class CategoriaSiteDemoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/categoria';

  Future<CategoriaSitePaginatedResponse> getSitesPaginated(
    int page,
    int limit, {
    CancelToken? cancelToken,
  }) async {
    final resp = await _dioClient.get('$_endpoint',
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: cancelToken);
    return CategoriaSitePaginatedResponse.fromJson(resp);
  }
}
