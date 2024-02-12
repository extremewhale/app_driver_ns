import 'package:app_driver_ns/data/models/vehiculo.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class VehiculoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/vehiculo';

  Future<VehiculoResponse> saveVehiculo(
      {required int idVehiculo,
      required int idConductor,
      required int idTipoVehiculo,
      required int idMarca,
      required String placa,
      required int asientos,
      required int maletas,
      required String foto,
      required int idModelo,
      required int idColor,
      required String urlLicenciaConducir,
      required bool valLicenciaConducir,
      required String urlSoat,
      required bool valSoat,
      required String urlRevisionTecnica,
      required bool valRevisionTecnica,
      required String urlResolucionTaxi,
      required bool valResolucionTaxi,
      required String urlTarjetaCirculacion,
      required bool valTarjetaCirculacion,
      required String observacion,
      required bool valAntecedentesPenales,
      required bool valAntecedentesPoliciales,
      required String urlAntecedentesPenales,
      required String urlAntecedentesPoliciales,
      required String expiracionLicencia,
      required String expiracionSoat,
      required String expiracionRevision,
      required String expiracionResolucion,
      required String expiracionTarjetacirculacion,
      required String expiracionPenales,
      required String expiracionJudiciales}) async {
    final resp = await _dioClient.post('$_endpoint', data: {
      "idVehiculo": idVehiculo,
      "idConductor": idConductor,
      "idTipoVehiculo": idTipoVehiculo,
      "idMarca": idMarca,
      "placa": placa,
      "asientos": asientos,
      "maletas": maletas,
      "foto": foto,
      "idModelo": idModelo,
      "idColor": idColor,
      "urlLicenciaConducir": urlLicenciaConducir,
      "valLicenciaConducir": valLicenciaConducir,
      "urlSoat": urlSoat,
      "valSoat": valSoat,
      "urlRevisionTecnica": urlRevisionTecnica,
      "valRevisionTecnica": valRevisionTecnica,
      "urlResolucionTaxi": urlResolucionTaxi,
      "valResolucionTaxi": valResolucionTaxi,
      "urlTarjetaCirculacion": urlTarjetaCirculacion,
      "valTarjetaCirculacion": valTarjetaCirculacion,
      "observacion": observacion,
      "valAntecedentesPenales": valAntecedentesPenales,
      "valAntecedentesPoliciales": valAntecedentesPoliciales,
      "urlAntecedentesPenales": urlAntecedentesPenales,
      "urlAntecedentesPoliciales": urlAntecedentesPoliciales,
      "expiracionLicencia": expiracionLicencia,
      "expiracionSoat": expiracionSoat,
      "expiracionRevision": expiracionRevision,
      "expiracionResolucion": expiracionResolucion,
      "expiracionTarjetacirculacion": expiracionTarjetacirculacion,
      "expiracionPenales": expiracionPenales,
      "expiracionJudiciales": expiracionJudiciales,
      "idTipoPlaca": 1
    });
    return VehiculoResponse.fromJson(resp);
  }
}
