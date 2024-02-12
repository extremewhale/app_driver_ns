part of 'utils.dart';

Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
  ImageConfiguration configuration = ImageConfiguration(size: Size(20, 20));
  BitmapDescriptor bitmapDescriptor =
      await BitmapDescriptor.fromAssetImage(configuration, path);
  return bitmapDescriptor;
}

Future<BitmapDescriptor> createMarkerImageFromAssetResize(
    String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  Uint8List mrk = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
  return BitmapDescriptor.fromBytes(mrk);
}

LatLngBounds simulateBoundsFromCoords(LatLng fromPoint, LatLng toPoint) {
  double left = min(fromPoint.latitude, toPoint.latitude);
  double right = max(fromPoint.latitude, toPoint.latitude);
  double top = max(fromPoint.longitude, toPoint.longitude);
  double bottom = min(fromPoint.longitude, toPoint.longitude);
  LatLngBounds bounds = LatLngBounds(
    southwest: LatLng(left, bottom),
    northeast: LatLng(right, top),
  );
  return bounds;
}

LatLng convertStringToLatLng(String coords) {
  final arr = coords.split(',');
  return LatLng(double.parse('${arr[0]}'), double.parse('${arr[1]}'));
}

void addMarker(MarkerId markerId, double lat, double lng,
    BitmapDescriptor iconMarker, Map<MarkerId, Marker> markers,
    {bool fixed = false, double? rotation, bool flat = true}) {
  Marker marker = Marker(
    markerId: markerId,
    icon: iconMarker,
    position: LatLng(lat, lng),
    draggable: false,
    zIndex: 2,
    flat: flat,
    anchor: Offset(0.5, 0.5),
    rotation: rotation ?? 0.0,
  );
  if (fixed) {
    marker = marker.copyWith(
        anchorParam: const Offset(0.5, 1.0), rotationParam: 0.0);
  }
  markers[markerId] = marker;
}

class SplitterAddressName {
  String _street = '';
  String get street => this._street;
  String _city = '';
  String get city => this._city;

  SplitterAddressName(String fullAddress) {
    _extractAddressAndSubAddress(fullAddress);
  }

  void _extractAddressAndSubAddress(String fullname) {
    final arParts = fullname.split(',');
    String streetName = '';
    String cityName = '';
    if (arParts.length > 2) {
      for (var i = 0; i < arParts.length - 2; i++) {
        if (streetName.isNotEmpty) streetName += ', ';
        streetName += arParts[i].trim();
      }

      cityName = arParts[arParts.length - 2].trim();
    } else if (arParts.length == 2) {
      streetName = arParts[0].trim();
      cityName = arParts[0].trim();
    } else {
      streetName = arParts[0].trim();
      cityName = arParts[0].trim();
    }

    this._street = streetName;
    this._city = cityName;
  }
}
