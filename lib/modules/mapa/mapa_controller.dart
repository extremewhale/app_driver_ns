import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:app_driver_ns/data/models/cancelaciones_solicitudes.dart';
import 'package:app_driver_ns/data/models/notification_taxi_request.dart';
import 'package:app_driver_ns/data/models/travel_info.dart';
import 'package:app_driver_ns/data/providers/cancelaciones_solicitudes_provider.dart';
import 'package:app_driver_ns/data/providers/geofire_provider.dart';
import 'package:app_driver_ns/data/providers/servicio_provider.dart';
import 'package:app_driver_ns/data/providers/travel_info_provider.dart';
import 'package:app_driver_ns/data/services/shared_prefs_service.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
// import 'package:app_driver_ns/modules/initial/initial_controller.dart';
import 'package:app_driver_ns/modules/mapa/mapa_page.dart';
//import 'package:app_driver_ns/modules/native/background_location.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/themes/fresh_map_theme.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;
import 'package:maps_curved_line/maps_curved_line.dart';

enum ModoVista { inicial, solicitud, mensaje }

class MapaController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  // Instances
  late MapaController _self;
  late BuildContext _context;
  final lct.Location location = lct.Location.instance;
  final _authX = Get.find<AuthController>();
  // final _initialX = Get.find<InitialController>();
  final _geofireProvider = GeofireProvider();
  final _travelInfoProvider = TravelInfoProvider();
  final _servicioProvider = ServicioProvider();

  final _cancelacionesSolicitudesProvider = CancelacionesSolicitudesProvider();

  AudioCache _cache = AudioCache();
  AudioPlayer? _audioPlayer;

  // Drawer
  final drawerKey = GlobalKey<ScaffoldState>();
  final enableMenuAction = true.obs;

  // GetBuilders Id's
  final gbScaffold = 'gbScaffold';
  final gbOnlyMap = 'gbOnlyMap';
  final gbProgressBar = 'gbProgressBar';
  final gbMarkers = 'gbMarkers';
  final gbSlidePanel = 'gbSlidePanel';

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
  final isConnect = false.obs;

  // Streams
  StreamSubscription<Position>? _myPositionStream;
  StreamSubscription<DocumentSnapshot>? _statusSubscription;

  // View
  final modoVista = (ModoVista.inicial).obs;

  // Markers
  static const MARKER_MYPOSITION_ID = 'myposition';
  BitmapDescriptor? markerMyPosition;
  final markerMyPositionKey = GlobalKey();
  static const MARKER_NEWCLIENT_ID = 'newclient';
  BitmapDescriptor? markerNewClient;
  final markerNewClientKey = GlobalKey();

  // Animations
  AnimationController? _animationController;
  Animation<double>? animationTween;

  // Extra
  bool isDarkTheme = false;

  String nombreConductor = '';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _self = this;
    _init();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _animationController?.dispose();
    _myPositionStream?.cancel();
    _statusSubscription?.cancel();
    _audioPlayer?.stop();
    //BackgroundLocation.instance.stop();
    super.onClose();
  }

  void setContext(BuildContext c) {
    this._context = c;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final controller = await _mapController.future;
      onMapCreated(controller);
      _verifyBackgroundNotifications();
    }
  }

  // **************************************************
  // * BEGIN::CONFIGURACIÓN MAPA Y MI POSICIÓN
  // **************************************************
  void _init() async {
    verifyProfileData();

    // print('${_authX.backendUser?.fcm ?? ''}');
    nombreConductor = _authX.backendUser?.nombres ?? '';

    await Helpers.sleep(400); // Necesaria para los markers

    _animationController = AnimationController(
      duration: Duration(seconds: _initWaitTime),
      vsync: this,
    );
    animationTween =
        Tween(begin: Get.size.width - (akContentPadding * 4), end: 40.0)
            .animate(_animationController!);
    _animationController?.addListener(() {
      update([gbProgressBar]);
    });

    markerMyPosition = await Helpers.getCustomIcon(markerMyPositionKey);
    markerNewClient = await Helpers.getCustomIcon(markerNewClientKey);

    isConnect.value =
        await _geofireProvider.checkIfDriverExists(_authX.getUser!.uid);

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      checkConnectedInFirebase();
      _configPosition();
    } else {
      bool gpsEnabled = await location.requestService();
      if (gpsEnabled) {
        checkConnectedInFirebase();
        _configPosition();
      }
    }
  }

  void _configPosition() async {
    if (_self.isClosed) return;
    try {
      final lastPosition = await Geolocator.getLastKnownPosition();
      _myPosition = lastPosition ?? await determineFirstPosition();
      await _initialConfigMap();

      _setMyPositionMarker();
      update([gbOnlyMap]);
      await _myPositionStream?.cancel();
      if (_self.isClosed) return;
      _myPositionStream =
          Geolocator.getPositionStream().listen((Position position) {
        print('cambiando de posición');
        _myPosition = position;
        if (!isConnect.value) return;
        if (modoVista.value == ModoVista.inicial) {
          _setMyPositionMarker();
          _centerTo(LatLng(myPosition.latitude, myPosition.longitude));
          update([gbOnlyMap]);
          if (isConnect.value) {
            saveLocationInFirebase(_authX.getUser!.uid, myPosition.latitude,
                myPosition.longitude, myPosition.heading);
          }
        }
      });
    } catch (e) {
      Helpers.logger.e('Error en: _configPosition');
    }
  }

  Future<void> _initialConfigMap() async {
    if (!existsPosition && isLocalizando.value && !_self.isClosed) {
      existsPosition = true;
      initialPosition = CameraPosition(
        target: LatLng(myPosition.latitude, myPosition.longitude),
        zoom: defaultZoom,
      );
      await cambiarModoVista(ModoVista.inicial);
      await Future.delayed(Duration(milliseconds: 1500));
      update([gbOnlyMap]);
      isLocalizando.value = false;

      await Helpers.sleep(1500);
      _verifyBackgroundNotifications();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(freshMapTheme));
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  Future<void> _centerTo(LatLng target) async {
    if (_self.isClosed) return;
    final cameraPosition = CameraPosition(target: target, zoom: defaultZoom);
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    final controller = await _mapController.future;
    controller.animateCamera(cameraUpdate);
  }

  void _setMyPositionMarker() {
    markers
        .removeWhere((marker) => marker.markerId.value == MARKER_MYPOSITION_ID);
    markers.add(Marker(
      markerId: MarkerId(MARKER_MYPOSITION_ID),
      zIndex: 1,
      anchor: Offset(0.45, 0.6),
      position: LatLng(myPosition.latitude, myPosition.longitude),
      rotation: myPosition.heading,
      icon: markerMyPosition ?? BitmapDescriptor.defaultMarker,
    ));
  }

  void updatePaddingMap({double top = 0.0, double bottom = 0.0}) {
    mapInsetPadding = EdgeInsets.only(
        top: akContentPadding + top,
        bottom: akContentPadding + bottom,
        left: akContentPadding * 0.5,
        right: akContentPadding * 0.5);
    update([gbOnlyMap]);
  }

  bool _cambiandoModoVista = false;
  Future<void> cambiarModoVista(ModoVista modo) async {
    if (_cambiandoModoVista) return;
    _cambiandoModoVista = true;

    // final previousModo = modoVista.value;

    switch (modo) {
      case ModoVista.inicial:
        modoVista.value = modo;
        _removeMarkersAndPolylines();
        updatePaddingMap(bottom: 150.0);
        await Future.delayed(Duration(milliseconds: 800));
        _setMyPositionMarker();
        _centerTo(LatLng(myPosition.latitude, myPosition.longitude));
        update([gbOnlyMap]);
        break;

      case ModoVista.solicitud:
        modoVista.value = modo;
        updatePaddingMap(bottom: 305.0);
        await _audioPlayer?.stop();
        _audioPlayer =
            (await _cache.load('sounds/request_travel.mp3')) as AudioPlayer?;
        _initAnimations();
        break;

      case ModoVista.mensaje:
        modoVista.value = modo;
        _removeMarkersAndPolylines();
        updatePaddingMap(bottom: 180.0);
        await Future.delayed(Duration(milliseconds: 800));
        _setMyPositionMarker();
        _centerTo(LatLng(myPosition.latitude, myPosition.longitude));
        update([gbOnlyMap]);
        break;
    }

    _cambiandoModoVista = false;
  }
  // **************************************************
  // * END::CONFIGURACIÓN MAPA Y MI POSICIÓN
  // **************************************************

  Future<void> onCenterButtonTap() async {
    // _centerTo(LatLng(myPosition.latitude, myPosition.longitude));
  }

  // **************************************************
  // * BEGIN::CONECTADO/DESCONECTADO
  // **************************************************
  void checkConnectedInFirebase() {
    Stream<DocumentSnapshot> status =
        _geofireProvider.getLocationByIdStreamWithMetadata(_authX.getUser!.uid);
    _statusSubscription?.cancel();
    _statusSubscription = status.listen((DocumentSnapshot document) {
      if (document.exists) {
        isConnect.value = true;
        //  BackgroundLocation.instance.start();
      } else {
        isConnect.value = false;
        // BackgroundLocation.instance.stop();
      }
    });
  }

  void disconnect() {
    // _positionStream?.cancel();
    _geofireProvider.delete(_authX.getUser!.uid);
  }

  void toggleStatus() async {
    if (isConnect.value) {
      disconnect();
    } else {
      print('Guardando ');
      await connectToService(_authX.getUser!.uid, myPosition.latitude,
          myPosition.longitude, myPosition.heading);
      print('registro');
      _configPosition();
    }
  }

  Future<void> connectToService(
      String id, double lat, double lng, double heading) async {
    await _geofireProvider.create(id, lat, lng, heading);
  }

  Future<void> saveLocationInFirebase(
      String id, double lat, double lng, double heading) async {
    await _geofireProvider.updateOnlyLocation(id, lat, lng, heading);
  }
  // **************************************************
  // * END::CONECTADO/DESCONECTADO
  // **************************************************

  // **************************************************
  // * BEGIN::NOTIFICACIÓN ENTRANTE
  // **************************************************
  Timer? _timer;
  static final int _initWaitTime = 15;
  int waitTime = _initWaitTime;
  // New Request variables
  String nrqOrigenName = '';
  // LatLng? nrqClientCoords;
  static const POLYTOCLIENT = 'polytoclient';
  Polyline _polyToClient = new Polyline(
      polylineId: PolylineId(POLYTOCLIENT),
      width: 2,
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      color: akPrimaryColor);

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      waitTime = waitTime - 1;
      if (waitTime < 0) {
        _timer?.cancel();
        rejectTravel(false);
      }
    });
  }

  void _initAnimations() async {
    waitTime = _initWaitTime;
    _animationController?.reset();
    _animationController?.forward();
    _startTimer();
  }

  List<NotificationTaxiRequest> notificationQueue = [];

  Future<void> onNotificationRequestReceived(
      List<NotificationTaxiRequest> notifications) async {
    // if (kDebugMode) log('${notiData.toJson()}');
    // Agrega la notificación a la cola
    notificationQueue.addAll(notifications);

    // Muestra la notificación si no hay otra en pantalla
    showNotificationInQueue();
  }

  bool showingNotifications = false;
  NotificationTaxiRequest? currentNotiData;
  Future<void> showNotificationInQueue() async {
    /* await Helpers.sleep(5000);
    Get.snackbar('title', 'message', onTap: (_) {
      print('sdfs');
      Get.until((route) => Get.currentRoute == AppRoutes.MAPA);
    }, duration: Duration(seconds: 10)); */
    if (!isConnect.value) {
      // Si el conductor esta desconectado, se elimina el uid de Locations, NO mostramos las notificaciones
      // Así evitamos que serviceNow se actualice sobre un registro que no existe
      notificationQueue = [];
      return;
    }

    if (notificationQueue.isEmpty) {
      print('No hay notificaciones en cola');
      return;
    }

    if (modoVista.value == ModoVista.inicial && !showingNotifications) {
      print('Muestra ahora la notificación');

      if (Get.currentRoute != AppRoutes.MAPA) {
        InAppAlerts.showNewService(onTap: () {
          Get.closeCurrentSnackbar();
          Get.until((route) => Get.currentRoute == AppRoutes.MAPA);
        });
      }

      try {
        showingNotifications = true;
        currentNotiData = notificationQueue.first;
        notificationQueue.removeAt(0);
        final splitClientOC = currentNotiData!.origenCoords.split(',');
        final clientOrigenCoords = LatLng(
            double.parse(splitClientOC[0]), double.parse(splitClientOC[1]));
        // final destinoCoords = LatLng(-11.9598, -76.9875);
        final myCoords = LatLng(myPosition.latitude, myPosition.longitude);
        nrqOrigenName = currentNotiData!.origenName;
        _polyToClient = _polyToClient.copyWith(
            pointsParam:
                MapsCurvedLines.getPointsOnCurve(clientOrigenCoords, myCoords));
        polylines.add(_polyToClient);
        _setNewClientMarker(clientOrigenCoords);
        update([gbOnlyMap]);
        await cambiarModoVista(ModoVista.solicitud);
        await Future.delayed(Duration(milliseconds: 800));
        LatLngBounds bounds = simulateBoundsFromCoords(
            LatLng(_myPosition.latitude, _myPosition.longitude),
            clientOrigenCoords);
        final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
        final controller = await _mapController.future;
        controller.animateCamera(cameraUpdate);
      } catch (e) {
        String _m = e is ApiException
            ? e.message
            : '¡Opps! Hubo un error recibiendo la notificación.';
        Helpers.logger.e(_m);
        print(e.toString());
      }
    } else {
      print('Se mostrará después');
    }
  }

  Future<void> _verifyBackgroundNotifications() async {
    try {
      /* final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final encodedNoti = prefs.get('lastRequest');
      if (encodedNoti is String && encodedNoti.isNotEmpty) {
        prefs.remove('lastRequest');
        final notificationData = jsonDecode(encodedNoti);
        if (notificationData['type'] == 'TAXI_REQUEST') {
          final data = NotificationTaxiRequest.fromJson(notificationData);
          onNotificationRequestReceived(data);
        }
      } */

      final svdReq = await SharedPrefsService.getRequests();
      onNotificationRequestReceived(svdReq);
      // Limpiamos las notificaciones para que se no vuelvan a presentar
      await SharedPrefsService.cleanAllRequests();
    } catch (e) {
      print('Error en _verifyBackgroundNotifications: ${e.toString()}');
    }
  }

  Future<void> rejectTravel(bool fromUserTap) async {
    if (loadingAccepting.value) return;
    _animationController?.stop();
    _timer?.cancel();
    _audioPlayer?.stop();

    markers.remove(MarkerId('client'));
    update([gbOnlyMap]);
    await cambiarModoVista(ModoVista.inicial);

    if (fromUserTap) {
      tryCatch(
        code: () async {
          Map<String, dynamic> data = {
            'hash': currentNotiData!.hash,
            'rejectedBy': FieldValue.arrayUnion([_authX.getUser!.uid])
          };
          await _travelInfoProvider.update(
              _authX.getUser!, data, currentNotiData!.uidClient);
        },
        onError: (e) async => false,
      );

      final travelResp =
          await _travelInfoProvider.getByUidClient(currentNotiData!.uidClient);

      DateTime today = new DateTime.now();

      ParamsCancelacionesSolicitudes dataParamsCancelacionesSolicitudes =
          new ParamsCancelacionesSolicitudes(
              fecha: today,
              idCancelacionesSolicitudes: 0,
              idConductor: _authX.backendUser!.idConductor,
              idSolicitud: travelResp!.idSolicitud);

      final resp = await _cancelacionesSolicitudesProvider
          .create(dataParamsCancelacionesSolicitudes);
      //cambiar estado de servicio base de datos
      //cambiar estado de servicio base de datos
      const status = 5;
      await _servicioProvider.updateStatusService(
          status, travelResp.idServicio);

      Helpers.logger.wtf(resp.toJson().toString());
    }

    // Espera un momento antes de validar si hay más notificaciones por mostrar
    // Verificar que esté igual en Accept y Reject
    await Helpers.sleep(3000);
    showingNotifications = false;
    currentNotiData = null;
    if (notificationQueue.isNotEmpty) {
      showNotificationInQueue();
    }
  }

  final loadingAccepting = false.obs;
  void acceptTravel() async {
    if (currentNotiData == null) return;
    if (loadingAccepting.value) return;

    String? content;
    loadingAccepting.value = true;
    await tryCatch(
      self: _self,
      code: () async {
        _animationController?.stop();
        _timer?.cancel();
        _audioPlayer?.stop();

        final travelResp = await _travelInfoProvider
            .getByUidClient(currentNotiData!.uidClient);

        if (travelResp == null) {
          throw BusinessException(
              'El usuario ha cancelado la solicitud de taxi. Mantente conectado para seguir recibiendo notificaciones.');
        }

        if (travelResp.uidDriver != null) {
          throw BusinessException(
              'Otro conductor ha tomado el viaje. Mantente conectado para seguir recibiendo notificaciones.');
        }

        if (travelResp.status != TravelStatus.CREATED ||
            currentNotiData!.hash != travelResp.hash) {
          throw BusinessException(
              'Esta solicitud de viaje ya no se encuentra disponible. Mantente conectado para seguir recibiendo notificaciones.');
        }

        if (travelResp.uidDriver == null) {
          Map<String, dynamic> data = {
            'hash': currentNotiData!.hash,
            'idConductor': _authX.backendUser!.idConductor,
            'uidDriver': _authX.getUser!.uid,
            'status': statusValues.reverse?[TravelStatus.ACCEPTED]
          };

          await _travelInfoProvider.update(
              _authX.getUser!, data, currentNotiData!.uidClient);
          await _geofireProvider.createWorking(
            _authX.getUser!.uid,
            myPosition.latitude,
            myPosition.longitude,
            myPosition.heading,
            currentNotiData!.uidClient,
          );

          var servicio = (await _servicioProvider
                  .getById(travelResp.idServicio)) //  + 4500))
              .data;

          servicio.idConductor = _authX.backendUser!.idConductor;
          servicio.idVehiculo = _authX.backendUser!.vehiculos![0].idVehiculo;

          // Helpers.logger.wtf(_initialX.statusToEstadoId(TravelStatus.ACCEPTED));

          await _servicioProvider.update(servicio);

          // await _servicioProvider.update(servicio.copyWith(
          //     idEstadoServicio:
          //         _initialX.statusToEstadoId(TravelStatus.ACCEPTED)));

          Get.offNamed(AppRoutes.TRAVEL);

          //cambiar estado de servicio base de datos
          const status = 4;
          await _servicioProvider.updateStatusService(
              status, travelResp.idServicio);
        } else {
          content =
              'Otro conductor ha tomado el viaje. Mantente conectado para seguir recibiendo notificaciones.';
        }
      },
      onError: (e) async {
        if (e is FirebaseException) {
          if (e.code == 'permission-denied') {
            content =
                'Puede que el usuario canceló la búsqueda de servicio o el tiempo de espera ha terminado. Buscaremos si hay más notificaciones para mostrar.';
          }
        } else if (e is BusinessException) {
          content = e.message;
        }
        if (content != null) return false;
        return true;
      },
      onCancelRetry: () async {
        content =
            'No se pudo empezar el servicio debido a un error interno. Buscaremos si hay más notificaciones para mostrar.';
      },
    );
    loadingAccepting.value = false;

    if (content != null) {
      await _showModalMessage(_context, 'Viaje no iniciado', content ?? '');
      // Espera un momento antes de validar si hay más notificaciones por mostrar
      // Verificar que esté igual en Accept y Reject
      await Helpers.sleep(3000);
      showingNotifications = false;
      currentNotiData = null;
      if (notificationQueue.isNotEmpty) {
        showNotificationInQueue();
      }
    }
  }

  void _setNewClientMarker(LatLng coords) {
    markers
        .removeWhere((marker) => marker.markerId.value == MARKER_NEWCLIENT_ID);
    markers.add(Marker(
      markerId: MarkerId(MARKER_NEWCLIENT_ID),
      zIndex: 2,
      anchor: Offset(0.5, 0.5),
      position: coords,
      icon: markerNewClient ?? BitmapDescriptor.defaultMarker,
    ));
  }

  void _removeMarkersAndPolylines() {
    markers
        .removeWhere((marker) => marker.markerId.value == MARKER_NEWCLIENT_ID);
    polylines
        .removeWhere((polyline) => polyline.polylineId.value == POLYTOCLIENT);
  }
  // **************************************************
  // * END::NOTIFICACIÓN ENTRANTE
  // **************************************************

  // **************************************************
  // * BEGIN::PANEL VISUAL MANAGEMENT
  // **************************************************
  final lyInicialTitleKey = GlobalKey();
  final lyInicialBodyKey = GlobalKey();
  bool lyInicialPanelHeightUpdated = false;
  bool lyInicialHeightFromWidgets = false;
  double lyInicialPanelHeightOpen = 400;
  double lyInicialPanelHeightClosed = 165.0;

  void updateLyInicialPanelMaxHeight() {
    if (lyInicialPanelHeightUpdated) return;
    try {
      final rObjectTitle = lyInicialTitleKey.currentContext?.findRenderObject();
      final rBoxTitle = rObjectTitle as RenderBox;
      final rObjectBody = lyInicialBodyKey.currentContext?.findRenderObject();
      final rBoxBody = rObjectBody as RenderBox;
      final totalHeight = rBoxTitle.size.height + rBoxBody.size.height;
      final maxPanelHeight = (Get.height * 0.8);

      if (totalHeight < maxPanelHeight) {
        lyInicialPanelHeightOpen = totalHeight;
        lyInicialHeightFromWidgets = true;
      } else {
        lyInicialPanelHeightOpen = maxPanelHeight;
      }
      lyInicialPanelHeightUpdated = true;
      update([gbSlidePanel]);
    } catch (e) {
      print(e);
    }
  }
  // **************************************************
  // * END::PANEL VISUAL MANAGEMENT
  // **************************************************

  // **************************************************
  // * BEGGIN::LOGICA DE REQUERIMIENTOS
  // **************************************************
  final isPhotoIncomplete = true.obs;
  final isBankIncomplete = true.obs;
  final isLicenseIncomplete = true.obs;

  void verifyProfileData() {
    isPhotoIncomplete.value = !(_authX.backendUser!.foto != null &&
        _authX.backendUser!.foto!.isNotEmpty);
    isBankIncomplete.value = !(_authX.backendUser!.idBanco != null);
    isLicenseIncomplete.value = !(_authX.backendUser!.licencia != null &&
        _authX.backendUser!.licencia!.isNotEmpty);
  }

  void onBannerProfileComplete() {
    if (isPhotoIncomplete.value) {
      Get.toNamed(AppRoutes.PERFIL_DATOS);
    } else if (isBankIncomplete.value) {
      Get.toNamed(AppRoutes.PERFIL_BANCO);
    } else if (isLicenseIncomplete.value) {
      Get.toNamed(AppRoutes.PERFIL_LICENCIA);
    }
  }

  Future<void> _showModalMessage(
      BuildContext context, String title, String content) async {
    // No aplicamos await para hacer un efecto de transición
    cambiarModoVista(ModoVista.mensaje);
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(0),
      barrierDismissible: false,
      builder: (_) {
        return ModalBasic(
          title: title,
          content: content,
        );
      },
    );
    await cambiarModoVista(ModoVista.inicial);
  }
}
