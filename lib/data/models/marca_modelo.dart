// To parse this JSON data, do
//
//     final listMarcaModelosResponse = listMarcaModelosResponseFromJson(jsonString);

import 'dart:convert';

ListMarcaModelosResponse listMarcaModelosResponseFromJson(String str) => ListMarcaModelosResponse.fromJson(json.decode(str));

String listMarcaModelosResponseToJson(ListMarcaModelosResponse data) => json.encode(data.toJson());

class ListMarcaModelosResponse {
    ListMarcaModelosResponse({
        required this.success,
        required this.data,
    });

    final bool success;
    final Data data;

    factory ListMarcaModelosResponse.fromJson(Map<String, dynamic> json) => ListMarcaModelosResponse(
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
        required this.idMarca,
        required this.marca,
        required this.enable,
        required this.modelos,
    });

    final int idMarca;
    final String marca;
    final int enable;
    final List<MarcaModelo> modelos;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idMarca: json["idMarca"],
        marca: json["marca"],
        enable: json["enable"],
        modelos: List<MarcaModelo>.from(json["modelos"].map((x) => MarcaModelo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idMarca": idMarca,
        "marca": marca,
        "enable": enable,
        "modelos": List<dynamic>.from(modelos.map((x) => x.toJson())),
    };
}

class MarcaModelo {
    MarcaModelo({
        required this.idModelo,
        required this.modelo,
        required this.idMarca,
        required this.enable,
    });

    final int idModelo;
    final String modelo;
    final int idMarca;
    final int enable;

    factory MarcaModelo.fromJson(Map<String, dynamic> json) => MarcaModelo(
        idModelo: json["idModelo"],
        modelo: json["modelo"],
        idMarca: json["idMarca"],
        enable: json["enable"],
    );

    Map<String, dynamic> toJson() => {
        "idModelo": idModelo,
        "modelo": modelo,
        "idMarca": idMarca,
        "enable": enable,
    };
}
