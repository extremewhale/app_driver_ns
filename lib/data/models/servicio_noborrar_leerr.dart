// To parse this JSON data, do
//
//     final servicioResponse = servicioResponseFromJson(jsonString);
// TODO: VERIFICAR LINEAS ABAJO COMO SE ESTÁ PARSEANDO LA FECHA.
/* 
import 'dart:convert';

import 'package:intl/intl.dart';

ServicioResponse servicioResponseFromJson(String str) =>
    ServicioResponse.fromJson(json.decode(str));

String servicioResponseToJson(ServicioResponse data) =>
    json.encode(data.toJson());

class ServicioResponse {
  ServicioResponse({
    required this.success,
    this.data,
  });

  bool success;
  Servicio? data;

  factory ServicioResponse.fromJson(Map<String, dynamic> json) =>
      ServicioResponse(
        success: json["success"],
        data: Servicio.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Servicio {
  Servicio({
    required this.idServicio,
    this.fechaSalida,
    this.horaSalida,
    this.fechaLlegada,
    this.horaLlegada,
    required this.costo,
    required this.descuento,
    required this.total,
    this.idVehiculo,
    required this.idRuta,
    this.idRutaFinal,
    required this.idTipoServicio,
    required this.idEstadoServicio,
    required this.valoracionCliente,
    required this.valoracionConductor,
    required this.comentario,
    required this.cantPasajeros,
    required this.idSolicitud,
    this.idConductor,
    required this.totalFinal,
  });

  int idServicio;
  dynamic fechaSalida;
  String? horaSalida;
  dynamic fechaLlegada;
  String? horaLlegada;
  int costo;
  int descuento;
  int total;
  int? idVehiculo;
  int idRuta;
  int? idRutaFinal;
  int idTipoServicio;
  int idEstadoServicio;
  int valoracionCliente;
  int valoracionConductor;
  String comentario;
  int cantPasajeros;
  int idSolicitud;
  int? idConductor;
  int totalFinal;

  static final String _fmt = "yyyy-MM-dd'T'hh:mm:ss";

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
        idServicio: json["idServicio"],
        fechaSalida: json["fechaSalida"] != null
            ? DateFormat(_fmt).parse(json["fechaSalida"], true)
            : null,
        horaSalida: json["horaSalida"],
        fechaLlegada: json["fechaLlegada"] != null
            ? DateFormat(_fmt).parse(json["fechaLlegada"], true)
            : null,
        horaLlegada: json["horaLlegada"],
        costo: json["costo"],
        descuento: json["descuento"],
        total: json["total"],
        idVehiculo: json["idVehiculo"],
        idRuta: json["idRuta"],
        idRutaFinal: json["idRutaFinal"],
        idTipoServicio: json["idTipoServicio"],
        idEstadoServicio: json["idEstadoServicio"],
        valoracionCliente: json["valoracionCliente"],
        valoracionConductor: json["valoracionConductor"],
        comentario: json["comentario"],
        cantPasajeros: json["cantPasajeros"],
        idSolicitud: json["idSolicitud"],
        idConductor: json["idConductor"],
        totalFinal: json["totalFinal"],
      );

  Map<String, dynamic> toJson() => {
        "idServicio": idServicio,
        "fechaSalida": fechaSalida?.toIso8601String(),
        "horaSalida": horaSalida,
        "fechaLlegada": fechaLlegada?.toIso8601String(),
        "horaLlegada": horaLlegada,
        "costo": costo,
        "descuento": descuento,
        "total": total,
        "idVehiculo": idVehiculo,
        "idRuta": idRuta,
        "idRutaFinal": idRutaFinal,
        "idTipoServicio": idTipoServicio,
        "idEstadoServicio": idEstadoServicio,
        "valoracionCliente": valoracionCliente,
        "valoracionConductor": valoracionConductor,
        "comentario": comentario,
        "cantPasajeros": cantPasajeros,
        "idSolicitud": idSolicitud,
        "idConductor": idConductor,
        "totalFinal": totalFinal,
      };
}
*/