import 'dart:async';

import 'package:app_driver_ns/data/models/extra_charge.dart';
import 'package:app_driver_ns/data/models/pago.dart';
import 'package:app_driver_ns/data/models/travel_info.dart';
import 'package:app_driver_ns/data/providers/concepto_provider.dart';
import 'package:app_driver_ns/data/providers/geofire_provider.dart';
import 'package:app_driver_ns/data/providers/pago_provider.dart';
import 'package:app_driver_ns/data/providers/servicio_provider.dart';
import 'package:app_driver_ns/data/providers/travel_info_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/mapa/mapa_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/modules/travel/rating/travel_rating_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:get/get.dart';

class TravelFinishedController extends GetxController {
  late TravelFinishedController _self;
  final AuthController _authX = Get.find<AuthController>();

  final MapaController _mapaController = Get.put(MapaController());
  final _conductorProvider = ConductorProvider();
  GeofireProvider _geofireProvider = GeofireProvider();
  final _travelInfoProvider = TravelInfoProvider();
  final _conceptoProvider = ConceptoProvider();
  final _servicioProvider = ServicioProvider();
  final _pagoProvider = PagoProvider();

  String detalleTotal = '';
  final costo = ''.obs;
  final total = ''.obs;
  final descuento = ''.obs;

  String extraLabel = '';
  final extraTotal = ''.obs;

  bool loadingData = false;
  final loadingPayment = false.obs;

  String? uidClient;

  @override
  void onInit() {
    super.onInit();
    _self = this;
    _init();
  }

  void _init() async {
    _getTravelData();
  }

  Future<void> _getTravelData() async {
    bool isOk = false;
    String? errorMsg;
    try {
      loadingData = true;
      update(['gbPayBar', 'gbContent', 'gbBottom']);
      final driverLocation =
          await _geofireProvider.getLocationById(_authX.getUser!.uid);
      uidClient = driverLocation['serviceNow'];
      final tvl = await _travelInfoProvider.getByUidClient(uidClient!);

      if (tvl != null) {
        if (tvl.startDate != null && tvl.finishDate != null) {
          final distance = tvl.estimatedDistance;
          final duration = tvl.finishDate!.difference(tvl.startDate!).inSeconds;

          var servicio =
              (await _servicioProvider.getById(tvl.idServicio)) //  + 4500))
                  .data;

          // costo = (tvl.costo - tvl.descuento).toStringAsFixed(2);
          // total.value = (tvl.costo - tvl.descuento).toStringAsFixed(2);
          isOk = true;

          final resp = await _conceptoProvider.simulacionTaxi(
              metros: distance,
              segundos: duration,
              idTipoVehiculo: servicio.idTipoVehiculo);

          if (resp.success) {
            final data = resp.data;
            final calculado = data.precioCalculado;
            costo.value = calculado;
            total.value = costo.value;

            updateCostTravel();
            // _beginTravelListener();
            isOk = true;
          }
        }
      }
    } on FirebaseException catch (e) {
      errorMsg = AppIntl.getFirebaseErrorMessage(e.code);
    } catch (e) {
      Helpers.logger.e('Error in getTravelData: ${e.toString()}');
    }

    if (_self.isClosed) return;

    if (isOk) {
      loadingData = false;
      update(['gbPayBar', 'gbContent', 'gbBottom']);
    } else {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        _getTravelData();
      }
    }
  }

  void updateCostTravel() async {
    tryCatch(
      code: () async {
        final driverLocation =
            await _geofireProvider.getLocationById(_authX.getUser!.uid);
        uidClient = driverLocation['serviceNow'];
        final tvl = await _travelInfoProvider.getByUidClient(uidClient!);
        Map<String, dynamic> data = {
          'hash': tvl!.hash,
          'costo': double.parse(costo.value),
          // 'descuento': 0.toDouble(),
          'total': double.parse(total.value),
        };

        await _travelInfoProvider.update(_authX.getUser!, data, uidClient!);

        _beginTravelListener();
      },
      onError: (e) async => false,
    );
  }

  void goToChargesPage() async {
    final result = await Get.toNamed(AppRoutes.TRAVEL_CHARGES);
    if (result is ExtraCharge) {
      extraLabel = result.shortText;
      extraTotal.value = double.parse(result.finalAmount).toStringAsFixed(2);
      double sum = double.parse(costo.value) + double.parse(result.finalAmount);

      total.value = sum.toStringAsFixed(2);

      updateCostTravel();

      update(['gbTotal']);
    }
  }

  void removeExtraCharges() async {
    // total.value = costo;

    final tvl = await _travelInfoProvider.getByUidClient(uidClient!);
    total.value = tvl!.costo.toString();

    extraLabel = '';
    extraTotal.value = '';

    updateCostTravel();

    update(['gbTotal']);
  }

  int idServicio = 0;

  void goToRatingPage() {
    _deleteTravelInfo();
    Get.toNamed(AppRoutes.TRAVEL_RATING,
        arguments: TravelRatingArguments(idServicioOld: idServicio));
  }

  void finishPaymentAndContinue() async {
    final resp = await _conductorProvider
        .getBilleteraConductor(_authX.backendUser!.idConductor);
    double montoTotal = double.parse(resp.saldoactual.toString());
    if (montoTotal <= 0.00) {
      _mapaController.isConnect.value = false;
      _mapaController.disconnect();
    }

    final tvl = await _travelInfoProvider.getByUidClient(uidClient!);
    idServicio = tvl!.idServicio;

    var servicio = (await _servicioProvider.getById(idServicio)) //  + 4500))
        .data;

    servicio.idEstadoServicio = 8;
    servicio.costo = tvl.total;
    servicio.descuento = tvl.descuento;

    servicio.total =
        double.parse((tvl.total - tvl.descuento).toStringAsFixed(2));

    await _servicioProvider.update(servicio);

    final newPago = PagoCreateParams(
        idPago: 0,
        idSolicitud: servicio.idSolicitud ?? 0,
        importe: (servicio.total).toString(),
        enable: 1,
        numeroOperacion: "999",
        numeroTarjeta: "999",
        idTipoTarjeta: 1,
        efectivo: 1);
    final result = await _pagoProvider.create(newPago);
    if (result.success) {}

    // TODO: MEJORAAR CON LOADINGS Y TIEMPOS DE ESPERA PARA HACER EL PAGO
    await _geofireProvider.finishWorking(_authX.getUser!.uid);

    goToRatingPage();
  }

  void finishPaymentAndOffline() async {
    final resp = await _conductorProvider
        .getBilleteraConductor(_authX.backendUser!.idConductor);
    double montoTotal = double.parse(resp.saldoactual.toString());
    if (montoTotal <= 0.00) {
      _mapaController.isConnect.value = false;
      _mapaController.disconnect();
    }
    final tvl = await _travelInfoProvider.getByUidClient(uidClient!);
    idServicio = tvl!.idServicio;

    // TODO: MEJORAAR CON LOADINGS Y TIEMPOS DE ESPERA PARA HACER EL PAGO
    await _geofireProvider.finishWorking(_authX.getUser!.uid);

    _geofireProvider.delete(_authX.getUser!.uid);
    goToRatingPage();
  }

  Future<void> _deleteTravelInfo() async {
    if (uidClient == null) return;
    try {
      await _travelInfoProvider.delete(uidClient!);
    } catch (e) {
      Helpers.logger.e('Hubo un error en _deleteTravelInfo');
      Helpers.logger.e(e);
    }
  }

  StreamSubscription<DocumentSnapshot>? _travelStatusSub;

  final idCupon = 0.obs;
  final cuponDescuento = "".obs;

  void _beginTravelListener() async {
    _travelStatusSub?.cancel();
    final driverLocation =
        await _geofireProvider.getLocationById(_authX.getUser!.uid);
    uidClient = driverLocation['serviceNow'];
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStreamWithMetaChanges(uidClient!);
    _travelStatusSub = stream.listen((DocumentSnapshot document) {
      // Helpers.logger.wtf(document.data().toString());

      TravelInfo tvl =
          TravelInfo.fromJson(document.data() as Map<String, dynamic>);

      double extraT = 0;
      if (extraTotal.value == "") {
        extraT = double.parse("0");
      }

      costo.value = tvl.costo.toString();
      descuento.value = tvl.descuento.toString();
      // total.value = (double.parse(costo.value) + extraT - double.parse(descuento.value)).toString();
      total.value = (tvl.total - tvl.descuento).toStringAsFixed(2);
    });
  }
}
