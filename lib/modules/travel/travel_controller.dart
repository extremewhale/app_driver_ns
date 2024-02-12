import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:app_driver_ns/data/models/cancelaciones_servicios.dart';
import 'package:app_driver_ns/data/models/cliente.dart';
import 'package:app_driver_ns/data/models/conductor.dart';
import 'package:app_driver_ns/data/models/ruta.dart';
import 'package:app_driver_ns/data/models/sosservicio.dart';
import 'package:app_driver_ns/data/models/travel_info.dart';
import 'package:app_driver_ns/data/providers/cancelaciones_servicios_provider.dart';
import 'package:app_driver_ns/data/providers/cliente_provider.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/data/providers/geofire_provider.dart';
import 'package:app_driver_ns/data/providers/push_notifications.dart';
import 'package:app_driver_ns/data/providers/ruta_provider.dart';
import 'package:app_driver_ns/data/providers/servicio_provider.dart';
import 'package:app_driver_ns/data/providers/sosservicio_provider.dart';
import 'package:app_driver_ns/data/providers/travel_info_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/modules/travel/emergency_options.dart';
import 'package:app_driver_ns/modules/travel/enter_secure/travel_enter_secure_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/themes/fresh_map_theme.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

enum ModoVistaT { unique }

class TravelController extends GetxController with WidgetsBindingObserver {
  // Instances
  late TravelController _self;
  final lct.Location location = lct.Location.instance;
  final _authX = Get.find<AuthController>();
  final _travelInfoProvider = TravelInfoProvider();
  final _geofireProvider = GeofireProvider();
  final _servicioProvider = ServicioProvider();
  final _rutaProvider = RutaProvider();
  final _conductorProvider = ConductorProvider();
  final _clienteProvider = ClienteProvider();
  final _pushNotificationsProvider = PushNotificationsProvider();
  final _polylinePointsLib = PolylinePoints();
  final _cancelacionesServiciosProvider = CancelacionesServiciosProvider();

  // Mapa
  bool existsPosition = false;
  final isLocalizando = true.obs;
  CameraPosition? initialPosition;
  final defaultZoom = 18.0;
  final _mapController = Completer<GoogleMapController>();
  EdgeInsets mapInsetPadding = EdgeInsets.all(0);
  final Set<Marker> markers = HashSet<Marker>();
  final Set<Polyline> polylines = HashSet<Polyline>();

  // Mi ubicación
  late Position _myPosition;
  Position get myPosition => this._myPosition;

  // Streams
  StreamSubscription<Position>? _myPositionStream;
  StreamSubscription<DocumentSnapshot>? _streamTravelSub;

  final modoVista = Rx<ModoVistaT>(ModoVistaT.unique);

  /* String? uidClient;
  String? idServicio;
  String? fcmClientToken; */

  TravelInfo? _travelInfo;

  final GlobalKey<SlideActionState> finishSlideKey = GlobalKey();

  BitmapDescriptor? markerDriver;
  BitmapDescriptor? markerClient;
  final driverMarkerId = MarkerId('driver');
  final clientMarkerId = MarkerId('client');

  // Markers
  static const MARKER_ORIGEN_ID = 'origen';
  static const MARKER_DESTINO_ID = 'destino';
  static const MARKER_MYPOSITION_ID = 'myposition';
  final markerOrigenKey = GlobalKey();
  final markerDestinoKey = GlobalKey();
  final markerMyPositionKey = GlobalKey();
  final markerDriverKey = GlobalKey();
  BitmapDescriptor? _markerOrigen;
  BitmapDescriptor? _markerDestino;
  BitmapDescriptor? _markerMyPosition;
  BitmapDescriptor? _markerDriver;
  /* static const POLYVIAJEKEY = 'polyviajekey';
  Polyline _polyViaje = new Polyline(
      polylineId: PolylineId(POLYVIAJEKEY), width: 3, color: akPrimaryColor); */

  // Default StylePolyline
  static const POLYPARTIDAKEY = 'polypartidakey';
  Polyline _polyPartida = new Polyline(
      polylineId: PolylineId(POLYPARTIDAKEY),
      width: 2,
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      color: akPrimaryColor);

  static const POLYVIAJEKEY = 'polyviajekey';
  Polyline _polyViaje = new Polyline(
      polylineId: PolylineId(POLYVIAJEKEY), width: 3, color: akPrimaryColor);

  String nombrePasajero = ''; // Primer nombre

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    _self = this;

    _init();
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    _myPositionStream?.cancel();
    _streamTravelSub?.cancel();

    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final controller = await _mapController.future;
      onMapCreated(controller);
    }
  }

  void _init() async {
    await Helpers.sleep(400);

    _markerOrigen = await Helpers.getCustomIcon(markerOrigenKey);
    _markerDestino = await Helpers.getCustomIcon(markerDestinoKey);
    _markerMyPosition = await Helpers.getCustomIcon(markerMyPositionKey);
    _markerDriver = await Helpers.getCustomIcon(markerDriverKey);

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      _configPosition();
    } else {
      bool gpsEnabled = await location.requestService();
      if (gpsEnabled) {
        _configPosition();
      }
    }
  }

  void _configPosition() async {
    if (_self.isClosed) return;
    /* addMarker(clientMarkerId, clientLatLng!.latitude, clientLatLng!.longitude,
        markerClient!, markers,
        fixed: true, flat: false); */
    try {
      final lastPosition = await Geolocator.getLastKnownPosition();
      _myPosition = lastPosition ?? await determineFirstPosition();
      await _initialConfigMap();
      // _setMyPositionMarker();
      _configMarkers(
          driverPos: LatLng(myPosition.latitude, myPosition.longitude),
          heading: myPosition.heading);
      onCompassButtonTap();

      _getInitialData();

      await _myPositionStream?.cancel();
      if (_self.isClosed) return;
      _myPositionStream =
          Geolocator.getPositionStream().listen((Position position) {
        _myPosition = position;
        // _setMyPositionMarker();
        _updateDriverPosition();
        // onCenterButtonTap();
        saveLocationInFirebase(_authX.getUser!.uid, myPosition.latitude,
            myPosition.longitude, myPosition.heading);
      });
    } catch (e) {
      print('Error en la localización: $e');
    }
  }

  Future<void> saveLocationInFirebase(
      String id, double lat, double lng, double heading) async {
    await _geofireProvider.updateOnlyLocation(id, lat, lng, heading);
  }

  Future<void> _initialConfigMap() async {
    if (!existsPosition && isLocalizando.value && !_self.isClosed) {
      existsPosition = true;
      initialPosition = CameraPosition(
        target: LatLng(myPosition.latitude, myPosition.longitude),
        zoom: defaultZoom,
      );
      update(['gbOnlyMap']);
      await Helpers.sleep(400);
      await cambiarModoVista(ModoVistaT.unique);
      await Helpers.sleep(2000);
      update(['gbOnlyMap']);
    }
  }

  Future<void> centerTo(LatLng target,
      {double bearing = 0.0, double tilt = 0.0}) async {
    if (_self.isClosed) return;
    final cameraPosition = CameraPosition(
        target: target, zoom: defaultZoom, bearing: bearing, tilt: tilt);
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    final controller = await _mapController.future;
    controller.animateCamera(cameraUpdate);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(freshMapTheme));
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  void onButtonCenterTap() async {
    // _startStreamTravel();
  }

  // Ruta
  Ruta? ruta;

  ConductorDto? conductor;
  ClienteCreateParams? cliente;

  String origenNombre = '';
  String destinoNombre = '';
  LatLng? origenCoords;
  LatLng? destinoCoords;
  // LatLng? driverCoords;
  // double? driverHeading;

  String uidClient = '';

  Future<void> _getInitialData() async {
    String? errorMsg;
    try {
      // await Helpers.sleep(4000);
      print('traer info de firestore');

      final driverLocationResp =
          await _geofireProvider.getLocationById(_authX.getUser!.uid);
      if (!driverLocationResp.exists) {
        throw BusinessException('No se encontraron los datos del conductor.');
      }

      final driverLocation = driverLocationResp.data() as Map<String, dynamic>;
      if (driverLocation['serviceNow'] == null) {
        throw BusinessException('No tiene un servicio asignado.');
      }
      uidClient = driverLocation['serviceNow'];
      _travelInfo = await _travelInfoProvider.getByUidClient(uidClient);
      _travelInfoProvider.setIdServicioAll(_travelInfo!.idServicio);
      if (_travelInfo != null &&
          _travelInfo!.idConductor != null &&
          _travelInfo!.uidDriver != null) {
        final conductorResp =
            await _conductorProvider.getById(_travelInfo!.idConductor!);
        if (conductorResp.success) {
          conductor = conductorResp.data;
          final servicioResp =
              await _servicioProvider.getById(_travelInfo!.idServicio);
          if (servicioResp.success) {
            final idRuta = servicioResp.data.idRuta;
            if (idRuta != null) {
              final rutaResp = await _rutaProvider.getById(idRuta);
              if (rutaResp.success && rutaResp.data != null) {
                ruta = rutaResp.data;
                update(['gbSlidePanel']);
                origenCoords = convertStringToLatLng(ruta!.coordenadaOrigen!);
                destinoCoords = convertStringToLatLng(ruta!.coordenadaDestino!);

                origenNombre = ruta!.nombreOrigen ?? '';
                destinoNombre = ruta!.nombreDestino ?? '';

                final strPolyline = ruta!.polyline!;
                final points = _polylinePointsLib.decodePolyline(strPolyline);
                final routeCoords = points
                    .map((point) => LatLng(point.latitude, point.longitude))
                    .toList();
                _polyViaje = _polyViaje.copyWith(pointsParam: routeCoords);

                await _configMarkers(origenPos: origenCoords);
                update(['gbOnlyMap']);
                _updateDriverPosition();
              }
            }
          }
        }
      }
    } on FirebaseException catch (e) {
      errorMsg = AppIntl.getFirebaseErrorMessage(e.code);
      Helpers.logger.e(e.code);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e('Error en getInitialData:' + e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _getInitialData();
      } else {
        print(
            'Cancelar... que hacer????'); // TODO: QUE HACER CUANDO EL ERROR NO SE PUEDE SOLUCIONAR
      }
    } else {
      _getClientData(_travelInfo!.uidClient);
    }
  }

  Future<void> _getClientData(String uidClient) async {
    String? errorMsg;
    try {
      final clienteResp = await _clienteProvider.searchByUid(uidClient);
      if (clienteResp.success) {
        cliente = clienteResp.data;
        nombrePasajero =
            Helpers.getShortName(true, clienteResp.data?.nombres ?? '');
      } else {
        throw BusinessException('No se pudo obtener los datos del cliente.');
      }
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _getClientData(uidClient);
      } else {
        print(
            'Cancelar... que hacer????'); // TODO: QUE HACER CUANDO EL ERROR NO SE PUEDE SOLUCIONAR
      }
    } else {
      isLocalizando.value = false;
      _startStreamTravel();
    }
  }

  bool travelFinished = false;

  void _startStreamTravel() async {
    print('_startStreamTravel');
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStreamWithMetaChanges(uidClient);
    _streamTravelSub?.cancel();
    if (_self.isClosed) return;
    _streamTravelSub = stream.listen((DocumentSnapshot document) async {
      if (document.data() == null) return;

      if (document.metadata.isFromCache) {
        return;
      }
      await Helpers.sleep(1000);
      final data = document.data() as Map<String, dynamic>;

      final travelInfo = TravelInfo.fromJson(data);

      travelStatus = travelInfo.status;

      if (travelStatus == TravelStatus.ACCEPTED) {
        travelStatusLabel.value = 'Recoger a $nombrePasajero';
        _cameraType = _MapCameraSelected.compass;
      } else if (travelStatus == TravelStatus.ARRIVED) {
        travelStatusLabel.value = 'Esperar a $nombrePasajero por 5 min';
        _cameraType = _MapCameraSelected.compass;
      } else if (travelStatus == TravelStatus.STARTED) {
        travelStatusLabel.value = 'Ir al lugar de destino';
        _cameraType = _MapCameraSelected.bounds;
      } else if (travelStatus == TravelStatus.FINISHED) {
        if (!travelFinished) {
          // Para evitar llamadas twices
          travelFinished = true;

          Get.offAllNamed(AppRoutes.TRAVEL_FINISHED);
          return;
        }
      } else if (travelStatus == TravelStatus.CANCELED) {
        Get.offAllNamed(AppRoutes.CANCELACION_SERVICIO);
        return;
      }

      switch (travelStatus) {
        case TravelStatus.ACCEPTED:
        case TravelStatus.ARRIVED:
          final sdn = SplitterAddressName(origenNombre);
          gpsCardSubTitle = sdn.city;
          gpsCardTitle.value = sdn.street;
          break;
        default:
          final sdn = SplitterAddressName(destinoNombre);
          gpsCardSubTitle = sdn.city;
          gpsCardTitle.value = sdn.street;
          break;
      }

      confirmButtonLoading = false;
      update(['gbConfirmButton']);

      _updateDriverPosition();
    });
  }

  Future<void> _updateDriverPosition() async {
    if (origenCoords == null || destinoCoords == null) return;

    await _configMarkers(
        driverPos: LatLng(myPosition.latitude, myPosition.longitude),
        heading: myPosition.heading);

    if (travelStatus == TravelStatus.ACCEPTED ||
        travelStatus == TravelStatus.ARRIVED) {
      _removePolyline(POLYPARTIDAKEY);
      markers.removeWhere((e) => e.markerId.value == MARKER_DESTINO_ID);
      polylines.removeWhere((e) => e.polylineId.value == POLYVIAJEKEY);
      _setPolylinePartida();
    } else if (travelStatus == TravelStatus.STARTED) {
      _removePolyline(POLYPARTIDAKEY);
      bool existsDestinoMkr = false;
      markers.forEach((e) {
        if (e.markerId.value == MARKER_DESTINO_ID) {
          existsDestinoMkr = true;
        }
      });
      if (!existsDestinoMkr) {
        await _configMarkers(destinoPos: destinoCoords);
      }

      bool existsPolyViaje = false;
      polylines.forEach((e) {
        if (e.polylineId.value == POLYVIAJEKEY) {
          existsPolyViaje = true;
        }
      });
      if (!existsPolyViaje) {
        polylines.add(_polyViaje);
      }
    }
    update(['gbOnlyMap']);

    if (_cameraType == _MapCameraSelected.compass) {
      onCompassButtonTap();
    } else if (_cameraType == _MapCameraSelected.bounds) {
      onBoundsButtonTap();
    }
  }

  void _setPolylinePartida() {
    if (origenCoords != null) {
      _polyPartida = _polyPartida.copyWith(
          pointsParam: MapsCurvedLines.getPointsOnCurve(origenCoords!,
              LatLng(myPosition.latitude, myPosition.longitude)));
      polylines.add(_polyPartida);
    }
  }

  void _removePolyline(String polylineId) {
    polylines
        .removeWhere((polyline) => polyline.polylineId.value == polylineId);
  }

  void onRetryInitalData() {
    _getInitialData();
  }

  void sendNotificationArrived() {
    if (_travelInfo != null && _travelInfo!.fcmClientToken != null) {
      Map<String, dynamic> data = {};
      _pushNotificationsProvider.sendMessage(_travelInfo!.fcmClientToken!, data,
          'Tu conductor ha llegado', 'Aproxímate al lugar de recogida.');
    }
  }

  Future<void> cambiarModoVista(ModoVistaT modo) async {
    modoVista.value = modo;
    if (modo == ModoVistaT.unique) {
      updatePaddingMap(bottom: 0.0); // 172.0)
    }
  }

  Future<void> updatePaddingMap({double top = 0.0, double bottom = 0.0}) async {
    final newPadding = EdgeInsets.only(
        top: akContentPadding + 110.0,
        bottom: akContentPadding + bottom,
        left: akContentPadding * 0.5,
        right: akContentPadding * 0.75);
    if (newPadding != mapInsetPadding) {
      mapInsetPadding = newPadding;
      update(['gbOnlyMap']);
    }
  }

  TravelStatus travelStatus = TravelStatus.ACCEPTED;
  final travelStatusLabel = 'Cargando información...'.obs;
  bool confirmButtonLoading = false;

  void onConfirmSubmit() async {
    confirmButtonLoading = true;
    update(['gbConfirmButton']);

    if (travelStatus == TravelStatus.ACCEPTED) {
      await _arriveTravel();
    } else if (travelStatus == TravelStatus.ARRIVED) {
      await _startTravel();
    } else if (travelStatus == TravelStatus.STARTED) {
      await _finishTravel();
    }
    // Finaliza el loading en el stream de TravelInfo
  }

  Future<void> _arriveTravel() async {
    final statusString = statusValues.reverse?[TravelStatus.ARRIVED];
    final data = {'hash': _travelInfo!.hash, 'status': statusString};
    await _travelInfoProvider.update(_authX.getUser!, data, uidClient);
    //cambiar estado de servicio base de datos
    const status = 6;
    await _servicioProvider.updateStatusService(
        status, _travelInfo!.idServicio);
  }

  Future<void> _startTravel() async {
    // Helpers.logger.wtf(_travelInfo!.code);

    final result = await Get.toNamed(AppRoutes.TRAVEL_ENTER_SECURE,
        arguments: TravelEnterSecureArguments(_travelInfo!.code.toString()));
    if (result != true) {
      confirmButtonLoading = false;
      update(['gbConfirmButton']);
      return;
    }
    /* AppSnackbar().success(
        message: 'Código válidado. Iniciando viaje...',
        duration: Duration(seconds: 2)); */
    final statusString = statusValues.reverse?[TravelStatus.STARTED];
    final data = {
      'hash': _travelInfo!.hash,
      'status': statusString,
      'startDate': FieldValue.serverTimestamp()
    };
    await _travelInfoProvider.update(_authX.getUser!, data, uidClient);
    //cambiar estado de servicio base de datos
    const status = 7;
    await _servicioProvider.updateStatusService(
        status, _travelInfo!.idServicio);
  }

  Future<void> _finishTravel() async {
    if (destinoCoords == null) return;
    final distanceToFinish = Geolocator.distanceBetween(
        myPosition.latitude,
        myPosition.longitude,
        destinoCoords!.latitude,
        destinoCoords!.longitude);

    if (distanceToFinish <= 30000) {
      // 300
      final statusString = statusValues.reverse?[TravelStatus.FINISHED];
      final data = {
        'hash': _travelInfo!.hash,
        'status': statusString,
        'finishDate': FieldValue.serverTimestamp()
      };
      await _travelInfoProvider.update(_authX.getUser!, data, uidClient);
      //cambiar estado de servicio base de datos
      const status = 8;
      await _servicioProvider.updateStatusService(
          status, _travelInfo!.idServicio);
    } else {
      AppSnackbar().info(
          message: 'Debes estar cerca del destino para finalizar el viaje',
          duration: Duration(seconds: 2));
      await Helpers.sleep(600);
      confirmButtonLoading = false;
      update(['gbConfirmButton']);
    }
  }

  _MapCameraSelected _cameraType = _MapCameraSelected.compass;

  void onCompassButtonTap() async {
    _cameraType = _MapCameraSelected.compass;
    await updatePaddingMap(bottom: 0.0);
    centerTo(LatLng(myPosition.latitude, myPosition.longitude),
        bearing: myPosition.heading, tilt: 50.0);
  }

  void onBoundsButtonTap() async {
    if (destinoCoords != null && origenCoords != null) {
      _cameraType = _MapCameraSelected.bounds;
      await updatePaddingMap(bottom: 140.0);
      if (travelStatus == TravelStatus.ACCEPTED) {
        final bounds = simulateBoundsFromCoords(
            origenCoords!, LatLng(myPosition.latitude, myPosition.longitude));
        _adjustMapToBounds(bounds);
      } else if (travelStatus == TravelStatus.ARRIVED ||
          travelStatus == TravelStatus.STARTED) {
        final bounds = simulateBoundsFromCoords(
            destinoCoords!, LatLng(myPosition.latitude, myPosition.longitude));
        _adjustMapToBounds(bounds);
      }
    }
  }

  void _adjustMapToBounds(LatLngBounds? bounds) async {
    if (bounds == null) return;
    final controller = await _mapController.future;
    try {
      await controller.getVisibleRegion();
    } catch (e) {
      print('Error _adjustMapToBounds');
    }
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    controller.animateCamera(cameraUpdate);
  }

  Future<void> _configMarkers(
      {LatLng? origenPos,
      LatLng? destinoPos,
      LatLng? driverPos,
      double? heading}) async {
    if (origenPos != null) {
      markers
          .removeWhere((marker) => marker.markerId.value == MARKER_ORIGEN_ID);
      markers.add(Marker(
        zIndex: 1,
        anchor: Offset(0.15, 0.5),
        markerId: MarkerId(MARKER_ORIGEN_ID),
        position: origenPos,
        icon: _markerOrigen ?? BitmapDescriptor.defaultMarker,
      ));
    }

    if (destinoPos != null) {
      markers
          .removeWhere((marker) => marker.markerId.value == MARKER_DESTINO_ID);
      markers.add(Marker(
        zIndex: 2,
        anchor: Offset(0.15, 0.5),
        markerId: MarkerId(MARKER_DESTINO_ID),
        position: destinoPos,
        icon: _markerDestino ?? BitmapDescriptor.defaultMarker,
      ));
    }

    if (driverPos != null) {
      markers.removeWhere(
          (marker) => marker.markerId.value == MARKER_MYPOSITION_ID);
      markers.add(Marker(
        zIndex: 3,
        anchor: Offset(0.5, 0.6),
        markerId: MarkerId(MARKER_MYPOSITION_ID),
        position: driverPos,
        rotation: heading ?? 0.0,
        icon: _markerDriver ?? BitmapDescriptor.defaultMarker,
        flat: true,
      ));
    }
  }

  final gpsCardTitle = ''.obs;
  String gpsCardSubTitle = '';

  void launchURL() async {
    if (destinoCoords == null) return;

    String baseWaze = "waze://";
    bool canWaze = await canLaunch(baseWaze);
    if (canWaze) {
      await launch(baseWaze +
          "?ll=${destinoCoords!.latitude},${destinoCoords!.longitude}&navigate=yes");
      return;
    }

    String baseGMaps = "https://";
    bool canGMaps = await canLaunch(baseGMaps);
    if (canGMaps) {
      String queryParms = [
        'saddr=${myPosition.latitude},${myPosition.longitude}',
        'daddr=${destinoCoords!.latitude},${destinoCoords!.longitude}',
        'dir_action=navigate',
        'travelmode=driving'
      ].join('&');
      await launch('https://www.google.com/maps?$queryParms');
      return;
    } else {
      print('dsfaes');
    }

    print('no');
    // TODO: MOSTRAR ERROR
  }

  // **************************************************
  // * ADITIONAL MAP CONTROL
  // **************************************************
  final hideMapControlsButtons = true.obs;
  void onUserStartMoveMap(_) {
    hideMapControlsButtons.value = false;
    if (_cameraType != _MapCameraSelected.none) {
      _cameraType = _MapCameraSelected.none;
    }
  }

  // **************************************************
  // * SLIDER ACTIONS
  // **************************************************
  void onEmergencyBtnTap() {
    if (Get.overlayContext == null) return;
    showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        context: Get.overlayContext!,
        builder: (_) => EmergencyOptions());
  }

  // **************************************************
  // * SLIDER BOTTOM
  // **************************************************
  final slidePanelController = PanelController();
  final panelTitleKey = GlobalKey();
  final panelBodyKey = GlobalKey();
  bool panelHeightUpdated = false;
  bool heightFromWidgets = false;
  double panelHeightOpen = 400;
  double panelHeightClosed = 190.0;
  void updatePanelMaxHeight() {
    if (panelHeightUpdated) return;
    try {
      final rObjectTitle = panelTitleKey.currentContext?.findRenderObject();
      final rBoxTitle = rObjectTitle as RenderBox;
      final rObjectBody = panelBodyKey.currentContext?.findRenderObject();
      final rBoxBody = rObjectBody as RenderBox;
      final totalHeight = rBoxTitle.size.height + rBoxBody.size.height;
      final maxPanelHeight = (Get.height * 0.8);

      if (totalHeight < maxPanelHeight) {
        panelHeightOpen = totalHeight;
        heightFromWidgets = true;
      } else {
        panelHeightOpen = maxPanelHeight;
      }
      panelHeightUpdated = true;
      update(['gbSlidePanel']);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> handleBack(BuildContext context) async {
    if (slidePanelController.isPanelOpen) {
      slidePanelController.close();
      return false;
    }
    return false;
  }

  Future<void> cancelTravel() async {
    final driverLocationResp =
        await _geofireProvider.getLocationById(_authX.getUser!.uid);
    if (!driverLocationResp.exists) {
      throw BusinessException('No se encontraron los datos del conductor.');
    }

    final driverLocation = driverLocationResp.data() as Map<String, dynamic>;
    if (driverLocation['serviceNow'] == null) {
      throw BusinessException('No tiene un servicio asignado.');
    }
    uidClient = driverLocation['serviceNow'];
    _travelInfo = await _travelInfoProvider.getByUidClient(uidClient);

    final statusString = statusValues.reverse?[TravelStatus.CANCELED];

    final data = {
      'hash': _travelInfo!.hash,
      'status': statusString,
      'startDate': FieldValue.serverTimestamp(),
      'finishDate': FieldValue.serverTimestamp()
    };

    await _travelInfoProvider.update(_authX.getUser!, data, uidClient);

    DateTime today = new DateTime.now();

    ParamsCancelacionesServicios dataParamsCancelacionesServicios =
        new ParamsCancelacionesServicios(
            fecha: today,
            idCancelacionesServicios: 0,
            idConductor: _authX.backendUser!.idConductor,
            idServicio: _travelInfo!.idServicio);

    final resp = await _cancelacionesServiciosProvider
        .create(dataParamsCancelacionesServicios);

    Helpers.logger.wtf(resp.toJson().toString());

    //cambiar estado de servicio base de datos
    const status = 3;
    await _servicioProvider.updateStatusService(
        status, _travelInfo!.idServicio);
    //Get.offAllNamed(AppRoutes.LOGIN);
  }

  void call105() async {
    const number = '105';
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  final _sosservicioProvider = SosservicioProvider();

  void sendSOS() async {
    try {
      // loading.value = true;

      final response =
          await Helpers.confirmDialog('¿Seguro(a) que desea enviar la alerta?');
      _travelInfo = await _travelInfoProvider.getByUidClient(uidClient);
      if (response!) {
        final lastPosition = await Geolocator.getCurrentPosition();
        _myPosition = lastPosition;
        final newSosservicio = new SosservicioDto(
            idSosServicio: 0,
            fechaHora: DateTime.now(),
            motivo: '',
            enable: 1,
            idServicio: _travelInfo!.idServicio,
            tipoPersona: 'conductor',
            estado: 1,
            cordLat: _myPosition.latitude,
            cordLon: _myPosition.longitude);
        final result = await _sosservicioProvider.create(newSosservicio);
        AppSnackbar().info(message: 'ALERTA ENVIADA');
      }
    } on ApiException catch (e) {
      String errormsg = AppIntl.getFirebaseErrorMessage(e.message);
      Helpers.showError(errormsg);
    } catch (e) {
      Helpers.showError('¡Opps! Parece que hubo un problema.',
          devError: e.toString());
    } finally {
      // loading.value = false;
    }
  }
}

enum _MapCameraSelected { none, compass, bounds }
