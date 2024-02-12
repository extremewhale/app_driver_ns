import 'package:app_driver_ns/data/models/concepto.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class ConceptoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/concepto';

  Future<ConceptoSimulacionResponse> simulacionTaxi(
      {required int metros, required segundos, required idTipoVehiculo}) async {
    final resp = await _dioClient.post('$_endpoint/simulacion', data: {
      'idServicio': 0,
      'idTipoServicio': 8,
      'distance': metros,
      'duration': segundos,
      'idTipoVehiculo': idTipoVehiculo // TODO: Harcodeo
    });
    return ConceptoSimulacionResponse.fromJson(resp);
  }
}
