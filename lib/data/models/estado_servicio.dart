// To parse this JSON data, do
//
//     final listEstadoServicioResponse = listEstadoServicioResponseFromJson(jsonString);

import 'dart:convert';

ListEstadoServicioResponse listEstadoServicioResponseFromJson(String str) =>
    ListEstadoServicioResponse.fromJson(json.decode(str));

String listEstadoServicioResponseToJson(ListEstadoServicioResponse data) =>
    json.encode(data.toJson());

class ListEstadoServicioResponse {
  ListEstadoServicioResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.numberOfElements,
    required this.totalElements,
    required this.content,
  });

  final int pageNumber;
  final int pageSize;
  final int numberOfElements;
  final int totalElements;
  final List<EstadoServicio> content;

  factory ListEstadoServicioResponse.fromJson(Map<String, dynamic> json) =>
      ListEstadoServicioResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<EstadoServicio>.from(
            json["content"].map((x) => EstadoServicio.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class EstadoServicio {
  EstadoServicio({
    required this.idEstadoServicio,
    required this.code,
    required this.nombre,
    required this.enable,
  });

  final int idEstadoServicio;
  final String code;
  final String nombre;
  final int enable;

  factory EstadoServicio.fromJson(Map<String, dynamic> json) => EstadoServicio(
        idEstadoServicio: json["idEstadoServicio"],
        code: json["code"],
        nombre: json["nombre"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "idEstadoServicio": idEstadoServicio,
        "code": code,
        "nombre": nombre,
        "enable": enable,
      };
}
