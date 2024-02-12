import 'package:app_driver_ns/data/models/estado_servicio.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class EstadoServicioProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/estadoservicio';

  Future<ListEstadoServicioResponse> getServicios(
      {required int page, required int limit}) async {
    final response = await _dioClient
        .get('$_endpoint', queryParameters: {'page': page, 'limit': limit});
    return ListEstadoServicioResponse.fromJson(response);
  }
}
