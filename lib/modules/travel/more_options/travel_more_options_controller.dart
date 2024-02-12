import 'package:app_driver_ns/data/models/cancelaciones_servicios.dart';
import 'package:app_driver_ns/data/models/travel_info.dart';
import 'package:app_driver_ns/data/providers/cancelaciones_servicios_provider.dart';
import 'package:app_driver_ns/data/providers/geofire_provider.dart';
import 'package:app_driver_ns/data/providers/travel_info_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TravelMoreOptionsController extends GetxController {
  TravelInfo? _travelInfo;

  final _authX = Get.find<AuthController>();
  final _travelInfoProvider = TravelInfoProvider();
  final _cancelacionesServiciosProvider = CancelacionesServiciosProvider();
  final _geofireProvider = GeofireProvider();

  String uidClient = '';

  Future<void> cancelTravel() async {
    final driverLocationResp =
        await _geofireProvider.getLocationById(_authX.getUser!.uid);
    if (!driverLocationResp.exists) {
      throw BusinessException('No se encontraron los datos del conductor.');
    }

    final driverLocation = driverLocationResp.data() as Map<String, dynamic>;
    if (driverLocation['serviceNow'] == null) {
      throw BusinessException('No tiene un servicio asignado.');
    }
    uidClient = driverLocation['serviceNow'];
    _travelInfo = await _travelInfoProvider.getByUidClient(uidClient);

    final statusString = statusValues.reverse?[TravelStatus.FINISHED];

    final data = {
      'hash': _travelInfo!.hash,
      'status': statusString,
      'finishDate': FieldValue.serverTimestamp()
    };

    // Helpers.logger.e('data: ${data.toString()}');

    await _travelInfoProvider.update(_authX.getUser!, data, uidClient);

    DateTime today = new DateTime.now();

    ParamsCancelacionesServicios dataParamsCancelacionesServicios =
        new ParamsCancelacionesServicios(
            fecha: today,
            idCancelacionesServicios: 0,
            idConductor: _authX.backendUser!.idConductor,
            idServicio: _travelInfo!.idServicio);

    final resp = await _cancelacionesServiciosProvider
        .create(dataParamsCancelacionesServicios);

    Helpers.logger.wtf(resp);

    Get.offAllNamed(AppRoutes.MAPA);
  }
}
