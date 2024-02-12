// To parse this JSON data, do
//
//     final paramsCancelacionesServicios = paramsCancelacionesServiciosFromJson(jsonString);

import 'dart:convert';

ParamsCancelacionesServicios paramsCancelacionesServiciosFromJson(String str) =>
    ParamsCancelacionesServicios.fromJson(json.decode(str));

String paramsCancelacionesServiciosToJson(ParamsCancelacionesServicios data) =>
    json.encode(data.toJson());

class ParamsCancelacionesServicios {
  ParamsCancelacionesServicios({
    required this.idCancelacionesServicios,
    required this.idConductor,
    required this.idServicio,
    required this.fecha,
  });

  final int idCancelacionesServicios;
  final int idConductor;
  final int idServicio;
  final DateTime fecha;

  factory ParamsCancelacionesServicios.fromJson(Map<String, dynamic> json) =>
      ParamsCancelacionesServicios(
        idCancelacionesServicios: json["idCancelacionesServicios"],
        idConductor: json["idConductor"],
        idServicio: json["idServicio"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "idCancelacionesServicios": idCancelacionesServicios,
        "idConductor": idConductor,
        "idServicio": idServicio,
        "fecha": fecha.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final responseCancelacionesServicios = responseCancelacionesServiciosFromJson(jsonString);

ResponseCancelacionesServicios responseCancelacionesServiciosFromJson(
        String str) =>
    ResponseCancelacionesServicios.fromJson(json.decode(str));

String responseCancelacionesServiciosToJson(
        ResponseCancelacionesServicios data) =>
    json.encode(data.toJson());

class ResponseCancelacionesServicios {
  ResponseCancelacionesServicios({
    required this.success,
    required this.data,
  });

  final bool success;
  final Data data;

  factory ResponseCancelacionesServicios.fromJson(Map<String, dynamic> json) =>
      ResponseCancelacionesServicios(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.idCancelacionesServicios,
    required this.idConductor,
    required this.idServicio,
    required this.fecha,
  });

  final int idCancelacionesServicios;
  final int idConductor;
  final int idServicio;
  final DateTime fecha;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idCancelacionesServicios: json["idCancelacionesServicios"],
        idConductor: json["idConductor"],
        idServicio: json["idServicio"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "idCancelacionesServicios": idCancelacionesServicios,
        "idConductor": idConductor,
        "idServicio": idServicio,
        "fecha": fecha.toIso8601String(),
      };
}
