// To parse this JSON data, do
//
//     final listMarcaResponse = listMarcaResponseFromJson(jsonString);

import 'dart:convert';

ListMarcaResponse listMarcaResponseFromJson(String str) => ListMarcaResponse.fromJson(json.decode(str));

String listMarcaResponseToJson(ListMarcaResponse data) => json.encode(data.toJson());

class ListMarcaResponse {
    ListMarcaResponse({
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
    final List<Marca> content;

    factory ListMarcaResponse.fromJson(Map<String, dynamic> json) => ListMarcaResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<Marca>.from(json["content"].map((x) => Marca.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
    };
}

class Marca {
    Marca({
        required this.idMarca,
        required this.marca,
        required this.enable,
    });

    final int idMarca;
    final String marca;
    final int enable;

    factory Marca.fromJson(Map<String, dynamic> json) => Marca(
        idMarca: json["idMarca"],
        marca: json["marca"],
        enable: json["enable"],
    );

    Map<String, dynamic> toJson() => {
        "idMarca": idMarca,
        "marca": marca,
        "enable": enable,
    };
}
