import 'package:app_driver_ns/data/models/recargar.dart';

import 'package:app_driver_ns/data/models/yape_response.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';

class RecargarProvider {
  final DioClient _dioClient = Get.find<DioClient>();
  final String _endpoint = '/recargar';

  Future<YapeResponse> payment(
      {required Niubiz niubiz, required String commerce}) async {
    final response = await _dioClient.put('$_endpoint',
        queryParameters: {'commerce': commerce}, data: niubiz.toJson());
    return YapeResponse.fromJson(response);
  }
}
