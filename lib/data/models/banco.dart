// To parse this JSON data, do
//
//     final listBancoResponse = listBancoResponseFromJson(jsonString);

import 'dart:convert';

ListBancoResponse listBancoResponseFromJson(String str) =>
    ListBancoResponse.fromJson(json.decode(str));

String listBancoResponseToJson(ListBancoResponse data) =>
    json.encode(data.toJson());

class ListBancoResponse {
  ListBancoResponse({
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
  final List<Banco> content;

  factory ListBancoResponse.fromJson(Map<String, dynamic> json) =>
      ListBancoResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content:
            List<Banco>.from(json["content"].map((x) => Banco.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class Banco {
  Banco({
    required this.idBanco,
    required this.nombre,
    required this.iniciales,
    required this.enable,
  });

  final int idBanco;
  final String nombre;
  final String iniciales;
  final int enable;

  factory Banco.fromJson(Map<String, dynamic> json) => Banco(
        idBanco: json["idBanco"],
        nombre: json["nombre"],
        iniciales: json["iniciales"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "idBanco": idBanco,
        "nombre": nombre,
        "iniciales": iniciales,
        "enable": enable,
      };
}
