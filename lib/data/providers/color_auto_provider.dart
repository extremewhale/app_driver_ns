import 'package:app_driver_ns/data/models/color_auto.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class ColorAutoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/color';

  Future<ListColorAutoResponse> getAllColors(
      {required int page, required int limit}) async {
    final response = await _dioClient
        .get('$_endpoint', queryParameters: {'page': page, 'limit': limit});
    // print('Data: ' + response.toString());
    return ListColorAutoResponse.fromJson(response);
  }
}
