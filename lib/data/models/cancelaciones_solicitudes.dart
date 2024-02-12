// To parse this JSON data, do
//
//     final paramsCancelacionesSolicitudes = paramsCancelacionesSolicitudesFromJson(jsonString);

import 'dart:convert';

ParamsCancelacionesSolicitudes paramsCancelacionesSolicitudesFromJson(
        String str) =>
    ParamsCancelacionesSolicitudes.fromJson(json.decode(str));

String paramsCancelacionesSolicitudesToJson(
        ParamsCancelacionesSolicitudes data) =>
    json.encode(data.toJson());

class ParamsCancelacionesSolicitudes {
  ParamsCancelacionesSolicitudes({
    required this.idCancelacionesSolicitudes,
    required this.idConductor,
    required this.idSolicitud,
    required this.fecha,
  });

  final int idCancelacionesSolicitudes;
  final int idConductor;
  final int idSolicitud;
  final DateTime fecha;

  factory ParamsCancelacionesSolicitudes.fromJson(Map<String, dynamic> json) =>
      ParamsCancelacionesSolicitudes(
        idCancelacionesSolicitudes: json["idCancelacionesSolicitudes"],
        idConductor: json["idConductor"],
        idSolicitud: json["idSolicitud"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "idCancelacionesSolicitudes": idCancelacionesSolicitudes,
        "idConductor": idConductor,
        "idSolicitud": idSolicitud,
        "fecha": fecha.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final responseCancelacionesSolicitudes = responseCancelacionesSolicitudesFromJson(jsonString);

ResponseCancelacionesSolicitudes responseCancelacionesSolicitudesFromJson(
        String str) =>
    ResponseCancelacionesSolicitudes.fromJson(json.decode(str));

String responseCancelacionesSolicitudesToJson(
        ResponseCancelacionesSolicitudes data) =>
    json.encode(data.toJson());

class ResponseCancelacionesSolicitudes {
  ResponseCancelacionesSolicitudes({
    required this.success,
    required this.data,
  });

  final bool success;
  final Data data;

  factory ResponseCancelacionesSolicitudes.fromJson(
          Map<String, dynamic> json) =>
      ResponseCancelacionesSolicitudes(
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
    required this.idCancelacionesSolicitudes,
    required this.idConductor,
    required this.idSolicitud,
    required this.fecha,
  });

  final int idCancelacionesSolicitudes;
  final int idConductor;
  final int idSolicitud;
  final DateTime fecha;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idCancelacionesSolicitudes: json["idCancelacionesSolicitudes"],
        idConductor: json["idConductor"],
        idSolicitud: json["idSolicitud"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "idCancelacionesSolicitudes": idCancelacionesSolicitudes,
        "idConductor": idConductor,
        "idSolicitud": idSolicitud,
        "fecha": fecha.toIso8601String(),
      };
}
