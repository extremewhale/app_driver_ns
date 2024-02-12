import 'package:app_driver_ns/data/models/cancelaciones_servicios.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class CancelacionesServiciosProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/cancelacionesservicios';

  Future<ResponseCancelacionesServicios> create(
      ParamsCancelacionesServicios dto) async {
    DateTime today = new DateTime.now();
    final params = ParamsCancelacionesServicios(
        fecha: dto.fecha,
        idCancelacionesServicios: dto.idCancelacionesServicios,
        idConductor: dto.idConductor,
        idServicio: dto.idServicio);

    final resp = await _dioClient.post('$_endpoint', data: params.toJson());
    return ResponseCancelacionesServicios.fromJson(resp);
  }
}
