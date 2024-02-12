// To parse this JSON data, do
//
//     final conductorDto = conductorDtoFromJson(jsonString);

import 'dart:convert';

import 'package:app_driver_ns/data/models/vehiculo.dart';

ConductorDto conductorDtoFromJson(String str) =>
    ConductorDto.fromJson(json.decode(str));
String conductorDtoToJson(ConductorDto data) => json.encode(data.toJson());

class ConductorCreateOrUpdateParams {
  ConductorCreateOrUpdateParams(
      {required this.idConductor,
      required this.nombres,
      required this.apellidos,
      required this.numeroDocumento,
      required this.idTipoDocumento,
      required this.uid,
      required this.celular,
      required this.fechaValidacionCelular,
      required this.correo,
      required this.idBanco,
      required this.foto,
      required this.numeroCuenta,
      required this.numeroCuentaInterbancaria,
      required this.licencia,
      required this.idEstadoConductor,
      required this.fcm,
      required this.enable,
      required this.fechaRegistro,
      required this.montoRecarga});

  final int idConductor;
  final String? nombres;
  final String? apellidos;
  final String numeroDocumento;
  final int idTipoDocumento;
  final String? uid;
  final String? celular;
  final DateTime fechaValidacionCelular;
  final String? correo;
  final int? idBanco;
  final String? foto;
  final String? numeroCuenta;
  final String? numeroCuentaInterbancaria;
  final String? licencia;
  final int idEstadoConductor;
  final String? fcm;
  final int enable;
  final DateTime fechaRegistro;
  final double montoRecarga;

  factory ConductorCreateOrUpdateParams.fromJson(Map<String, dynamic> json) =>
      ConductorCreateOrUpdateParams(
          idConductor: json["idConductor"],
          nombres: json["nombres"],
          apellidos: json["apellidos"],
          numeroDocumento: json["numeroDocumento"],
          idTipoDocumento: json["idTipoDocumento"],
          uid: json["uid"],
          celular: json["celular"],
          fechaValidacionCelular:
              DateTime.parse(json["fechaValidacionCelular"]),
          correo: json["correo"],
          idBanco: json["idBanco"],
          foto: json["foto"],
          numeroCuenta: json["numeroCuenta"],
          numeroCuentaInterbancaria: json["numeroCuentaInterbancaria"],
          licencia: json["licencia"],
          idEstadoConductor: json["idEstadoConductor"],
          fcm: json["fcm"],
          enable: json["enable"],
          fechaRegistro: DateTime.parse(json["fechaRegistro"]),
          montoRecarga: json["montoRecarga"]);

  Map<String, dynamic> toJson() => {
        "idConductor": idConductor,
        "nombres": nombres,
        "apellidos": apellidos,
        "numeroDocumento": numeroDocumento,
        "idTipoDocumento": idTipoDocumento,
        "uid": uid,
        "celular": celular,
        "fechaValidacionCelular": fechaValidacionCelular.toIso8601String(),
        "correo": correo,
        "idBanco": idBanco,
        "foto": foto,
        "numeroCuenta": numeroCuenta,
        "numeroCuentaInterbancaria": numeroCuentaInterbancaria,
        "licencia": licencia,
        "idEstadoConductor": idEstadoConductor,
        "fcm": fcm,
        "enable": enable,
        "fechaRegistro": fechaRegistro.toIso8601String(),
        "montoRecarga": montoRecarga
      };
}

ConductorCreateResponse conductorCreateResponseFromJson(String str) =>
    ConductorCreateResponse.fromJson(json.decode(str));
String conductorCreateResponseToJson(ConductorCreateResponse data) =>
    json.encode(data.toJson());

class ConductorCreateResponse {
  ConductorCreateResponse({
    required this.success,
    required this.data,
  });

  bool success;
  ConductorDto data;

  factory ConductorCreateResponse.fromJson(Map<String, dynamic> json) =>
      ConductorCreateResponse(
        success: json["success"],
        data: ConductorDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

// To parse this JSON data, do
//
//     final conductorDto = conductorDtoFromJson(jsonString);

class ConductorDto {
  ConductorDto({
    required this.idConductor,
    this.nombres,
    this.apellidos,
    required this.numeroDocumento,
    required this.idTipoDocumento,
    required this.uid,
    this.celular,
    required this.fechaValidacionCelular,
    this.correo,
    this.idBanco,
    this.foto,
    this.numeroCuenta,
    this.numeroCuentaInterbancaria,
    required this.enable,
    this.licencia,
    required this.idEstadoConductor,
    this.fcm,
    this.vehiculos,
    required this.fechaRegistro,
    this.montoRecarga,
  });

  final int idConductor;
  final String? nombres;
  final String? apellidos;
  final String numeroDocumento;
  final int idTipoDocumento;
  final String uid;
  final String? celular;
  final DateTime fechaValidacionCelular;
  final String? correo;
  final int? idBanco;
  final String? foto;
  final String? numeroCuenta;
  final String? numeroCuentaInterbancaria;
  final int enable;
  final String? licencia;
  final int idEstadoConductor;
  final String? fcm;
  final List<Vehiculo>? vehiculos;
  final DateTime fechaRegistro;
  final double? montoRecarga;

  ConductorDto copyWith({
    int? idConductor,
    String? nombres,
    String? apellidos,
    String? numeroDocumento,
    int? idTipoDocumento,
    String? uid,
    String? celular,
    DateTime? fechaValidacionCelular,
    String? correo,
    int? idBanco,
    String? foto,
    String? numeroCuenta,
    String? numeroCuentaInterbancaria,
    int? enable,
    String? licencia,
    int? idEstadoConductor,
    String? fcm,
    List<Vehiculo>? vehiculos,
    DateTime? fechaRegistro,
    double? montoRecarga,
  }) =>
      ConductorDto(
        idConductor: idConductor ?? this.idConductor,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        numeroDocumento: numeroDocumento ?? this.numeroDocumento,
        idTipoDocumento: idTipoDocumento ?? this.idTipoDocumento,
        uid: uid ?? this.uid,
        celular: celular ?? this.celular,
        fechaValidacionCelular:
            fechaValidacionCelular ?? this.fechaValidacionCelular,
        correo: correo ?? this.correo,
        idBanco: idBanco ?? this.idBanco,
        foto: foto ?? this.foto,
        numeroCuenta: numeroCuenta ?? this.numeroCuenta,
        numeroCuentaInterbancaria:
            numeroCuentaInterbancaria ?? this.numeroCuentaInterbancaria,
        enable: enable ?? this.enable,
        licencia: licencia ?? this.licencia,
        idEstadoConductor: idEstadoConductor ?? this.idEstadoConductor,
        fcm: fcm ?? this.fcm,
        // Tener cuidado, siempre mantener los vehículos que se obtuvieron
        // al iniciar la aplicación
        vehiculos: vehiculos ?? this.vehiculos,
        fechaRegistro: fechaRegistro ?? this.fechaRegistro,
        montoRecarga: montoRecarga ?? this.montoRecarga,
      );

  factory ConductorDto.fromJson(Map<String, dynamic> json) => ConductorDto(
        idConductor: json["idConductor"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        numeroDocumento: json["numeroDocumento"],
        idTipoDocumento: json["idTipoDocumento"],
        uid: json["uid"],
        celular: json["celular"],
        fechaValidacionCelular: DateTime.parse(json["fechaValidacionCelular"]),
        correo: json["correo"],
        idBanco: json["idBanco"],
        foto: json["foto"],
        numeroCuenta: json["numeroCuenta"],
        numeroCuentaInterbancaria: json["numeroCuentaInterbancaria"],
        enable: json["enable"],
        licencia: json["licencia"],
        idEstadoConductor: json["idEstadoConductor"],
        fcm: json["fcm"],
        vehiculos: json["vehiculos"] == null
            ? null
            : List<Vehiculo>.from(
                json["vehiculos"].map((x) => Vehiculo.fromJson(x))),
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
        montoRecarga: json["montoRecarga"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "idConductor": idConductor,
        "nombres": nombres,
        "apellidos": apellidos,
        "numeroDocumento": numeroDocumento,
        "idTipoDocumento": idTipoDocumento,
        "uid": uid,
        "celular": celular,
        "fechaValidacionCelular": fechaValidacionCelular.toIso8601String(),
        "correo": correo,
        "idBanco": idBanco,
        "foto": foto,
        "numeroCuenta": numeroCuenta,
        "numeroCuentaInterbancaria": numeroCuentaInterbancaria,
        "enable": enable,
        "licencia": licencia,
        "idEstadoConductor": idEstadoConductor,
        "fcm": fcm,
        "vehiculos": vehiculos == null
            ? null
            : List<dynamic>.from(vehiculos!.map((x) => x.toJson())),
        "fechaRegistro": fechaRegistro.toIso8601String(),
        "montoRecarga": montoRecarga!.toDouble(),
      };
}

// To parse this JSON data, do
//
//     final conductorListResponse = conductorListResponseFromJson(jsonString);

ConductorListResponse conductorListResponseFromJson(String str) =>
    ConductorListResponse.fromJson(json.decode(str));

String conductorListResponseToJson(ConductorListResponse data) =>
    json.encode(data.toJson());

class ConductorListResponse {
  ConductorListResponse({
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
  final List<ConductorDto> content;

  factory ConductorListResponse.fromJson(Map<String, dynamic> json) =>
      ConductorListResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<ConductorDto>.from(
            json["content"].map((x) => ConductorDto.fromJson(x))),
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
//     final responseBilleteraParams = responseBilleteraParamsFromJson(jsonString);

ResponseBilleteraParams responseBilleteraParamsFromJson(String str) =>
    ResponseBilleteraParams.fromJson(json.decode(str));

String responseBilleteraParamsToJson(ResponseBilleteraParams data) =>
    json.encode(data.toJson());

class ResponseBilleteraParams {
  ResponseBilleteraParams(
      {this.saldoactual,
      this.conteoviajesdeldia,
      this.conteoviajesefectivo,
      this.totalefectivo,
      this.comisionefectivo,
      this.conteoviajestarjeta,
      this.totaltarjeta,
      this.comision_tarjeta,
      this.total_final,
      this.pendientepago});

  final String? saldoactual;
  final int? conteoviajesdeldia;
  final int? conteoviajesefectivo;
  final String? totalefectivo;
  final String? comisionefectivo;
  final int? conteoviajestarjeta;
  final String? totaltarjeta;
  final String? comision_tarjeta;
  final String? total_final;
  final String? pendientepago;

  factory ResponseBilleteraParams.fromJson(Map<String, dynamic> json) =>
      ResponseBilleteraParams(
          saldoactual: json['saldoactual'],
          conteoviajesdeldia: json['conteoviajesdeldia'],
          conteoviajesefectivo: json['conteoviajesefectivo'],
          totalefectivo: json['totalefectivo'],
          comisionefectivo: json['comisionefectivo'],
          conteoviajestarjeta: json['conteoviajestarjeta'],
          totaltarjeta: json['totaltarjeta'],
          comision_tarjeta: json['comision_tarjeta'],
          total_final: json['total_final'],
          pendientepago: json['pendientepago']);

  Map<String, dynamic> toJson() => {
        "saldoactual": saldoactual,
        "conteoviajesdeldia": conteoviajesdeldia,
        "conteoviajesefectivo": conteoviajesefectivo,
        "totalefectivo": totalefectivo,
        "comisionefectivo": comisionefectivo,
        "conteoviajestarjeta": conteoviajestarjeta,
        "totaltarjeta": totaltarjeta,
        "comision_tarjeta": comision_tarjeta,
        "total_final": total_final,
        "pendientepago": pendientepago,

        // "idBilleteraConductor": idBilleteraConductor,
        // "idConductor": idConductor,
        // "monto": monto,
        // "enable": enable,
        // "transacciones":
        //     List<dynamic>.from(transacciones!.map((x) => x.toJson())),
      };
}

class Transaccione {
  Transaccione({
    this.idTransaccionBilletera,
    this.idBilleteraConductor,
    this.monto,
    this.idTipoAbono,
    this.idLiquidacion,
    this.enable,
    this.billeteraConductor,
  });

  final int? idTransaccionBilletera;
  final int? idBilleteraConductor;
  final String? monto;
  final int? idTipoAbono;
  final int? idLiquidacion;
  final int? enable;
  final String? billeteraConductor;

  factory Transaccione.fromJson(Map<String, dynamic> json) => Transaccione(
        idTransaccionBilletera: json["idTransaccionBilletera"],
        idBilleteraConductor: json["idBilleteraConductor"],
        monto: json["monto"],
        idTipoAbono: json["idTipoAbono"],
        idLiquidacion: json["idLiquidacion"],
        enable: json["enable"],
        billeteraConductor: json["billeteraConductor"],
      );

  Map<String, dynamic> toJson() => {
        "idTransaccionBilletera": idTransaccionBilletera,
        "idBilleteraConductor": idBilleteraConductor,
        "monto": monto,
        "idTipoAbono": idTipoAbono,
        "idLiquidacion": idLiquidacion,
        "enable": enable,
        "billeteraConductor": billeteraConductor,
      };
}
