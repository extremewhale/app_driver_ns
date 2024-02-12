import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DrivingRequestParamType { latLng, placeId }

class DrivingRequestParam {
  late DrivingRequestParamType _type;
  DrivingRequestParamType get type => this._type;

  LatLng? _coords;
  LatLng? get coords => this._coords;

  String? _placeId;
  String? get placeId => this._placeId;

  DrivingRequestParam({
    required DrivingRequestParamType type,
    LatLng? coords,
    String? placeId,
  }) {
    _type = type;

    if (type == DrivingRequestParamType.latLng) {
      if (coords == null)
        throw Exception('Se debe proporcionar el parámetro coords');
    } else if (type == DrivingRequestParamType.placeId) {
      if (placeId == null)
        throw Exception('Se debe proporcionar el parámetro placeId');
    }

    _coords = coords;
    _placeId = placeId;
  }

  String getParamToString() {
    if (_type == DrivingRequestParamType.placeId) {
      return 'place_id:$_placeId';
    }
    return '${_coords!.latitude},${_coords!.longitude}';
  }
}
