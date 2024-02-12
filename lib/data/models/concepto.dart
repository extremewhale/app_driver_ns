// To parse this JSON data, do
//
//     final conceptoSimulacionResponse = conceptoSimulacionResponseFromJson(jsonString);

import 'dart:convert';

ConceptoSimulacionResponse conceptoSimulacionResponseFromJson(String str) =>
    ConceptoSimulacionResponse.fromJson(json.decode(str));

String conceptoSimulacionResponseToJson(ConceptoSimulacionResponse data) =>
    json.encode(data.toJson());

class ConceptoSimulacionResponse {
  ConceptoSimulacionResponse({
    required this.success,
    required this.data,
  });

  bool success;
  SimulacionResponseDto data;

  factory ConceptoSimulacionResponse.fromJson(Map<String, dynamic> json) =>
      ConceptoSimulacionResponse(
        success: json["success"],
        data: SimulacionResponseDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class SimulacionResponseDto {
  SimulacionResponseDto({
    required this.precioCalculado,
  });

  String precioCalculado;

  factory SimulacionResponseDto.fromJson(Map<String, dynamic> json) =>
      SimulacionResponseDto(
        precioCalculado: json["precioCalculado"],
      );

  Map<String, dynamic> toJson() => {
        "precioCalculado": precioCalculado,
      };
}
