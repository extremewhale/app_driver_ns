// To parse this JSON data, do
//
//     final appStatus = appStatusFromJson(jsonString);

import 'dart:convert';

List<AppStatus> appStatusFromJson(String str) =>
    List<AppStatus>.from(json.decode(str).map((x) => AppStatus.fromJson(x)));

String appStatusToJson(List<AppStatus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppStatus {
  AppStatus({
    required this.lastView,
    this.idClient,
    this.idDriver,
  });

  final LastView lastView;
  final String? idClient;
  final String? idDriver;

// lastViewValues.map[json["last_view"]]

  factory AppStatus.fromJson(Map<String, dynamic> json) {
    String jlv = json["last_view"] ?? 'DEFAULT';

    return AppStatus(
      lastView: lastViewValues.map[jlv] ?? LastView.DEFAULT,
      idClient: json["id_client"],
      idDriver: json["id_driver"],
    );
  }

  Map<String, dynamic> toJson() => {
        "last_view": lastViewValues.reverse?[lastView] ?? 'DEFAULT',
        "id_client": idClient,
        "id_driver": idDriver,
      };
}

// Si agrega más tipos, debe agregar también en el Map
enum LastView { DEFAULT, TRAVEL_REQUEST, TRACKING }

final lastViewValues = EnumValues({
  "DEFAULT": LastView.DEFAULT,
  "TRAVEL_REQUEST": LastView.TRAVEL_REQUEST,
  "TRACKING": LastView.TRACKING,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
