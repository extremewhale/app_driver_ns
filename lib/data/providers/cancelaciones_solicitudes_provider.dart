import 'package:app_driver_ns/data/models/cancelaciones_solicitudes.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class CancelacionesSolicitudesProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/cancelacionessolicitudes';

  Future<ResponseCancelacionesSolicitudes> create(
      ParamsCancelacionesSolicitudes dto) async {
    DateTime today = new DateTime.now();
    final params = ParamsCancelacionesSolicitudes(
        fecha: dto.fecha,
        idCancelacionesSolicitudes: dto.idCancelacionesSolicitudes,
        idConductor: dto.idConductor,
        idSolicitud: dto.idSolicitud);

    final resp = await _dioClient.post('$_endpoint', data: params.toJson());
    return ResponseCancelacionesSolicitudes.fromJson(resp);
  }
}
