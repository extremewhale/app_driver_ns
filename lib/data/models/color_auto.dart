// To parse this JSON data, do
//
//     final listColorAutoResponse = listColorAutoResponseFromJson(jsonString);

import 'dart:convert';

ListColorAutoResponse listColorAutoResponseFromJson(String str) =>
    ListColorAutoResponse.fromJson(json.decode(str));

String listColorAutoResponseToJson(ListColorAutoResponse data) =>
    json.encode(data.toJson());

class ListColorAutoResponse {
  ListColorAutoResponse({
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
  final List<ColorAuto> content;

  factory ListColorAutoResponse.fromJson(Map<String, dynamic> json) =>
      ListColorAutoResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<ColorAuto>.from(
            json["content"].map((x) => ColorAuto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final listColorResponse = listColorResponseFromJson(jsonString);

ListColorResponse listColorResponseFromJson(String str) =>
    ListColorResponse.fromJson(json.decode(str));

String listColorResponseToJson(ListColorResponse data) =>
    json.encode(data.toJson());

class ListColorResponse {
  ListColorResponse({
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
  final List<ColorAuto> content;

  factory ListColorResponse.fromJson(Map<String, dynamic> json) =>
      ListColorResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<ColorAuto>.from(
            json["content"].map((x) => ColorAuto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class ColorAuto {
  ColorAuto({
    required this.idColor,
    required this.color,
    required this.codigo,
    required this.enable,
  });

  final int idColor;
  final String color;
  final String codigo;
  final int enable;

  factory ColorAuto.fromJson(Map<String, dynamic> json) => ColorAuto(
        idColor: json["idColor"],
        color: json["color"],
        codigo: json["codigo"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "idColor": idColor,
        "color": color,
        "codigo": codigo,
        "enable": enable,
      };
}
