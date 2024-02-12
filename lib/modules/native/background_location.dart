import 'dart:async';

import 'package:flutter/services.dart';

class BackgroundLocation {
  BackgroundLocation._internal();

  static BackgroundLocation _instance = BackgroundLocation._internal();
  static BackgroundLocation get instance => _instance;

  final _methodChannel =
      MethodChannel('com.taxiwaa.app_driver_ns/background_location');

  // Como agregamos manualmente la data, no necesitamos hacer close al stream
  // ignore: close_sinks
  /* StreamController<Position> _controller = StreamController.broadcast();
  StreamSubscription? _geolocatorSubs;
  Stream<Position> get stream => _controller.stream; */
  bool _running = false;

  Future<void> start() async {
    if (_running) return;

    /* if (!Platform.isIOS) {
      await _geolocatorSubs?.cancel();
      _geolocatorSubs = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
          .listen((position) {
        print('getPositionStream');
        _controller.sink.add(position);
      });
    } else {
      Helpers.logger.i('Background not implemented for iOS');
    } */

    await _methodChannel.invokeMethod('start');
    _running = true;
  }

  Future<void> stop() async {
    // await _geolocatorSubs?.cancel();
    _running = false;
    await _methodChannel.invokeMethod('stop');
  }
}
