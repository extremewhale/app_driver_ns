import 'package:app_driver_ns/data/models/pago.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class PagoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/pago';

  Future<ResponseCreateParams> create(PagoCreateParams data) async {
    final resp = await _dioClient.post('$_endpoint', data: data.toJson());
    return ResponseCreateParams.fromJson(resp);
  }
}
