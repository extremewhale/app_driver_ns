import 'dart:convert';

YapeResponse yapeResponseFromJson(String str) =>
    YapeResponse.fromJson(json.decode(str));

String yapeResponseToJson(YapeResponse data) => json.encode(data.toJson());

class YapeResponse {
  int? statusCode;
  String? data;

  YapeResponse({
    this.statusCode,
    this.data,
  });

  factory YapeResponse.fromJson(Map<String, dynamic> json) => YapeResponse(
        statusCode: json["statusCode"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data,
      };
}
