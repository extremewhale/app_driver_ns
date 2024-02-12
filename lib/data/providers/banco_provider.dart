import 'package:app_driver_ns/data/models/banco.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class BancoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/banco';

  Future<ListBancoResponse> getAll(
      {required int page, required int limit}) async {
    final response = await _dioClient
        .get('$_endpoint', queryParameters: {'page': page, 'limit': limit});
    return ListBancoResponse.fromJson(response);
  }
}
