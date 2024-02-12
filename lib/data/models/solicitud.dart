// To parse this JSON data, do
//
//     final solicitudResponse = solicitudResponseFromJson(jsonString);

import 'dart:convert';

SolicitudResponse solicitudResponseFromJson(String str) =>
    SolicitudResponse.fromJson(json.decode(str));

String solicitudResponseToJson(SolicitudResponse data) =>
    json.encode(data.toJson());

class SolicitudResponse {
  SolicitudResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.numberOfElements,
    required this.totalElements,
    required this.content,
  });

  int pageNumber;
  int pageSize;
  int numberOfElements;
  int totalElements;
  List<Solicitud> content;

  factory SolicitudResponse.fromJson(Map<String, dynamic> json) =>
      SolicitudResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<Solicitud>.from(
            json["content"].map((x) => Solicitud.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class Solicitud {
  Solicitud({
    required this.idSolicitud,
    required this.idCliente,
    required this.enable,
    required this.idTipoSolicitud,
    this.fecha,
    this.total,
    this.cupon,
    this.totalFinal,
  });

  int idSolicitud;
  int idCliente;
  int enable;
  int idTipoSolicitud;
  DateTime? fecha;

  int? total;

  int? cupon;
  int? totalFinal;

  factory Solicitud.fromJson(Map<String, dynamic> json) => Solicitud(
        idSolicitud: json["idSolicitud"],
        fecha: DateTime.parse(json["fecha"]),
        idCliente: json["idCliente"],
        total: json["total"]?.toDouble(),
        enable: json["enable"]?.toDouble(),
        idTipoSolicitud: json["idTipoSolicitud"],
        cupon: json["cupon"]?.toDouble(),
        totalFinal: json["totalFinal"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "idSolicitud": idSolicitud,
        "fecha": fecha?.toIso8601String(),
        "idCliente": idCliente,
        "total": total,
        "enable": enable,
        "idTipoSolicitud": idTipoSolicitud,
        "cupon": cupon,
        "totalFinal": totalFinal,
      };
}
