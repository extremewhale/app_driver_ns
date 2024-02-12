import 'package:app_driver_ns/data/models/servicio.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class ServicioProvider {
  final DioClient _dioClient = Get.find<DioClient>();
  final _authX = Get.find<AuthController>();

  final String _endpoint = '/servicio';

  Future<ServicioPojoResponse> getById(int id) async {
    final resp = await _dioClient.get('$_endpoint/id?id=$id');
    return ServicioPojoResponse.fromJson(resp);
  }

  Future<ServicioPojoResponse> update(ServicioPojo data) async {
    final resp = await _dioClient.put(
      '$_endpoint?id=${data.idServicio}',
      data: data.toJson(),
    );
    return ServicioPojoResponse.fromJson(resp);
  }

  Future<ServicioList2Response> getByClient() async {
  /*   DateTime today = new DateTime.now();
    DateTime fiveDaysAgo = today.add(new Duration(days: 2));
 */
    int idConductor = _authX.backendUser!.idConductor;

    final resp = await _dioClient.get('$_endpoint/conductor', queryParameters: {
     /*  'desde': today,
      'hasta': fiveDaysAgo, */
      'idConductor': idConductor,
      'page': '1',
      'limit': '10',
    });
    return ServicioList2Response.fromJson(resp);
  }

   Future<ServicioPojoResponse> updateStatusService(int idStatus ,int id) async {
    final resp = await _dioClient.get('$_endpoint/update/status/{idstatus}/{idservice}?idStatus=$idStatus&idService=$id');
    return ServicioPojoResponse.fromJson(resp);
  }

}
