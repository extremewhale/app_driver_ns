// To parse this JSON data, do
//
//     final pagoCreateParams = pagoCreateParamsFromJson(jsonString);

import 'dart:convert';

PagoCreateParams pagoCreateParamsFromJson(String str) =>
    PagoCreateParams.fromJson(json.decode(str));

String pagoCreateParamsToJson(PagoCreateParams data) =>
    json.encode(data.toJson());

class PagoCreateParams {
  PagoCreateParams({
    required this.idPago,
    required this.idSolicitud,
    required this.importe,
    required this.enable,
    required this.numeroOperacion,
    required this.numeroTarjeta,
    required this.idTipoTarjeta,
    required this.efectivo,
  });

  final int idPago;
  final int idSolicitud;
  final String importe;
  final int enable;
  final String numeroOperacion;
  final String numeroTarjeta;
  final int idTipoTarjeta;
  final int efectivo;

  factory PagoCreateParams.fromJson(Map<String, dynamic> json) =>
      PagoCreateParams(
        idPago: json["idPago"],
        idSolicitud: json["idSolicitud"],
        importe: json["importe"],
        enable: json["enable"],
        numeroOperacion: json["numeroOperacion"],
        numeroTarjeta: json["numeroTarjeta"],
        idTipoTarjeta: json["idTipoTarjeta"],
        efectivo: json["efectivo"],
      );

  Map<String, dynamic> toJson() => {
        "idPago": idPago,
        "idSolicitud": idSolicitud,
        "importe": importe,
        "enable": enable,
        "numeroOperacion": numeroOperacion,
        "numeroTarjeta": numeroTarjeta,
        "idTipoTarjeta": idTipoTarjeta,
        "efectivo": efectivo,
      };
}

// To parse this JSON data, do
//
//     final responseCreateParams = responseCreateParamsFromJson(jsonString);

ResponseCreateParams responseCreateParamsFromJson(String str) =>
    ResponseCreateParams.fromJson(json.decode(str));

String responseCreateParamsToJson(ResponseCreateParams data) =>
    json.encode(data.toJson());

class ResponseCreateParams {
  ResponseCreateParams({
    required this.success,
    required this.data,
  });

  final bool success;
  final Data data;

  factory ResponseCreateParams.fromJson(Map<String, dynamic> json) =>
      ResponseCreateParams(
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
    required this.idPago,
    required this.idSolicitud,
    required this.importe,
    required this.enable,
    required this.numeroOperacion,
    required this.numeroTarjeta,
    required this.idTipoTarjeta,
    required this.efectivo,
  });

  final int idPago;
  final int idSolicitud;
  final String importe;
  final int enable;
  final String numeroOperacion;
  final String numeroTarjeta;
  final int idTipoTarjeta;
  final int efectivo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idPago: json["idPago"],
        idSolicitud: json["idSolicitud"],
        importe: json["importe"],
        enable: json["enable"],
        numeroOperacion: json["numeroOperacion"],
        numeroTarjeta: json["numeroTarjeta"],
        idTipoTarjeta: json["idTipoTarjeta"],
        efectivo: json["efectivo"],
      );

  Map<String, dynamic> toJson() => {
        "idPago": idPago,
        "idSolicitud": idSolicitud,
        "importe": importe,
        "enable": enable,
        "numeroOperacion": numeroOperacion,
        "numeroTarjeta": numeroTarjeta,
        "idTipoTarjeta": idTipoTarjeta,
        "efectivo": efectivo,
      };
}
