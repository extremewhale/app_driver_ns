// To parse this JSON data, do
//
//     final vehiculoResponse = vehiculoResponseFromJson(jsonString);

import 'dart:convert';

VehiculoResponse vehiculoResponseFromJson(String str) =>
    VehiculoResponse.fromJson(json.decode(str));

String vehiculoResponseToJson(VehiculoResponse data) =>
    json.encode(data.toJson());

class VehiculoResponse {
  VehiculoResponse({
    required this.success,
    required this.data,
  });

  final bool success;
  final Vehiculo data;

  factory VehiculoResponse.fromJson(Map<String, dynamic> json) =>
      VehiculoResponse(
        success: json["success"],
        data: Vehiculo.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Vehiculo {
  Vehiculo({
    required this.idVehiculo,
    required this.idConductor,
    required this.idMarca,
    required this.placa,
    required this.asientos,
    required this.maletas,
    required this.foto,
    required this.idModelo,
    required this.urlLicenciaConducir,
    required this.valLicenciaConducir,
    required this.urlSoat,
    required this.valSoat,
    required this.urlRevisionTecnica,
    required this.valRevisionTecnica,
    required this.urlResolucionTaxi,
    required this.valResolucionTaxi,
    required this.urlTarjetaCirculacion,
    required this.valTarjetaCirculacion,
    required this.observacion,
    required this.expiracionLicencia,
    required this.valAntecedentesPenales,
    required this.valAntecedentesPoliciales,
    required this.urlAntecedentesPenales,
    required this.urlAntecedentesPoliciales,
    required this.expiracionSoat,
    required this.expiracionRevision,
    required this.expiracionResolucion,
    required this.expiracionTarjetacirculacion,
    required this.expiracionPenales,
    required this.expiracionJudiciales,
    this.idColor,
    required this.idTipoPlaca,
  });

  final int idVehiculo;
  final int idConductor;
  final int idMarca;
  final String placa;
  final int asientos;
  final int maletas;
  final String foto;
  final int idModelo;
  final String urlLicenciaConducir;
  final bool valLicenciaConducir;
  final String urlSoat;
  final bool valSoat;
  final String urlRevisionTecnica;
  final bool valRevisionTecnica;
  final String urlResolucionTaxi;
  final bool valResolucionTaxi;
  final String urlTarjetaCirculacion;
  final bool valTarjetaCirculacion;
  final String observacion;
  final int? idColor;
  final bool valAntecedentesPenales;
  final bool valAntecedentesPoliciales;
  final String? urlAntecedentesPenales;
  final String? urlAntecedentesPoliciales;
  final String? expiracionLicencia;
  final String? expiracionSoat;
  final String? expiracionRevision;
  final String? expiracionResolucion;
  final String? expiracionTarjetacirculacion;
  final String? expiracionPenales;
  final String? expiracionJudiciales;
  final int? idTipoPlaca;

  factory Vehiculo.fromJson(Map<String, dynamic> json) => Vehiculo(
      idVehiculo: json["idVehiculo"],
      idConductor: json["idConductor"],
      idMarca: json["idMarca"],
      placa: json["placa"],
      asientos: json["asientos"],
      maletas: json["maletas"],
      foto: json["foto"],
      idModelo: json["idModelo"],
      urlLicenciaConducir: json["urlLicenciaConducir"],
      valLicenciaConducir: json["valLicenciaConducir"],
      urlSoat: json["urlSoat"],
      valSoat: json["valSoat"],
      urlRevisionTecnica: json["urlRevisionTecnica"],
      valRevisionTecnica: json["valRevisionTecnica"],
      urlResolucionTaxi: json["urlResolucionTaxi"],
      valResolucionTaxi: json["valResolucionTaxi"],
      urlTarjetaCirculacion: json["urlTarjetaCirculacion"],
      valTarjetaCirculacion: json["valTarjetaCirculacion"],
      observacion: json["observacion"],
      idColor: json["idColor"],
      valAntecedentesPenales: json["valAntecedentesPenales"],
      valAntecedentesPoliciales: json["valAntecedentesPoliciales"],
      urlAntecedentesPenales: json["urlAntecedentesPenales"],
      urlAntecedentesPoliciales: json["urlAntecedentesPoliciales"],
      expiracionLicencia: json["expiracionLicencia"],
      expiracionSoat: json["expiracionSoat"],
      expiracionRevision: json["expiracionRevision"],
      expiracionResolucion: json["expiracionResolucion"],
      expiracionTarjetacirculacion: json["expiracionTarjetacirculacion"],
      expiracionPenales: json["expiracionPenales"],
      expiracionJudiciales: json["expiracionJudiciales"],
      idTipoPlaca: json["idTipoPlaca"]);

  Map<String, dynamic> toJson() => {
        "idVehiculo": idVehiculo,
        "idConductor": idConductor,
        "idMarca": idMarca,
        "placa": placa,
        "asientos": asientos,
        "maletas": maletas,
        "foto": foto,
        "idModelo": idModelo,
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
        "idColor": idColor,
        "expiracionLicencia": expiracionLicencia,
        "valAntecedentesPenales": valAntecedentesPenales,
        "valAntecedentesPoliciales": valAntecedentesPoliciales,
        "urlAntecedentesPenales": urlAntecedentesPenales,
        "urlAntecedentesPoliciales": urlAntecedentesPoliciales,
        "expiracionSoat": expiracionSoat,
        "expiracionRevision": expiracionRevision,
        "expiracionResolucion": expiracionResolucion,
        "expiracionTarjetacirculacion": expiracionTarjetacirculacion,
        "expiracionPenales": expiracionPenales,
        "expiracionJudiciales": expiracionJudiciales,
        "idTipoPlaca": idTipoPlaca
      };
}
