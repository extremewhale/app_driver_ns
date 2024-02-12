import 'package:app_driver_ns/data/models/conductor.dart';
import 'package:app_driver_ns/data/models/estado_servicio.dart';
import 'package:app_driver_ns/data/models/travel_info.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/data/providers/estado_servicio_provider.dart';
import 'package:app_driver_ns/data/providers/geofire_provider.dart';
import 'package:app_driver_ns/data/providers/servicio_provider.dart';
import 'package:app_driver_ns/data/services/notification_service.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/modules/requisitos/requisitos_controller.dart';
import 'package:app_driver_ns/modules/secure/login_flow/login_flow_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialController extends GetxController {
  final _authX = Get.find<AuthController>();

  final _estadoServicioProvider = EstadoServicioProvider();
  final _servicioProvider = ServicioProvider();
  final _conductorProvider = ConductorProvider();
  final _geofireProvider = GeofireProvider();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> firstLogic() async {
    // await _loadMasterLists();
    _updateFcmToken();
    _preloadPhoto();

    await _verifyRequirementsLogic();
  }

  /// Valida que el conductor cumpla todos los requisitos.
  /// Si cumple, continúa con la validación de viajes activos.
  Future<void> _verifyRequirementsLogic() async {
    final conductor = _authX.backendUser!;

    // Validamos que lista vehículos no sea null
    if (conductor.vehiculos == null) {
      String errorMsg = 'Hubo un error obteniendo la lista de vehículos';
      await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
    } else {
      // --------------
      // Empiezan las validaciones de los documentos del conductor.
      // --------------
      final isCompleted = _isRequirementsCompleted(conductor);
      final existsOservation = _checkExistsObservation(conductor);
      if (!isCompleted || existsOservation) {
        bool _isFromLogin = false;
        try {
          final LoginFlowController? _existsLoginX =
              Get.find<LoginFlowController>();
          _isFromLogin = _existsLoginX != null;
        } catch (e) {}

        Get.offAllNamed(
          AppRoutes.REQUISITOS,
          arguments: RequisitosArguments(
            enableBack: false,
            shoWelcomeDialog: _isFromLogin,
            showFixDocuments: !_isFromLogin,
          ),
        );
      } else {
        final isValidated = _isRequirementsValidated(conductor);

        if (!isValidated) {
          Get.offAllNamed(AppRoutes.REQUISITOS_REVISION);
        } else {
          _checkTravelActive();
        }
      }
    }
  }

  /// Verifica los documentos del conductor se hayan llenado.
  bool _isRequirementsCompleted(ConductorDto conductor) {
    bool isCompleted = true;

    if (conductor.vehiculos!.isNotEmpty) {
      for (var i = 0; i < conductor.vehiculos!.length; i++) {
        final v = conductor.vehiculos![i];
        if (v.idColor == null) {
          // TODO: aaregar marca
          isCompleted = false;
          break;
        }

        if (v.urlLicenciaConducir.isEmpty ||
            v.urlSoat.isEmpty ||
            v.urlRevisionTecnica.isEmpty ||
            v.urlResolucionTaxi.isEmpty ||
            v.urlTarjetaCirculacion.isEmpty) {
          isCompleted = false;
          break;
        }
      }
    } else {
      isCompleted = false;
    }

    return isCompleted;
  }

  /// Verifica los documentos hayan sido validados por administración.
  bool _isRequirementsValidated(ConductorDto conductor) {
    bool isValidated = true;

    if (conductor.vehiculos!.isNotEmpty) {
      for (var i = 0; i < conductor.vehiculos!.length; i++) {
        final v = conductor.vehiculos![i];

        if (!(v.valLicenciaConducir &&
            v.valSoat &&
            v.valRevisionTecnica &&
            v.valResolucionTaxi &&
            v.valTarjetaCirculacion)) {
          isValidated = false;
          break;
        }
      }
    } else {
      isValidated = false;
    }

    return isValidated;
  }

  /// Verifica si existe algun observación sobre los documentos
  bool _checkExistsObservation(ConductorDto conductor) {
    bool hasObservationOrError = false;

    if (conductor.vehiculos!.isNotEmpty) {
      for (var i = 0; i < conductor.vehiculos!.length; i++) {
        final v = conductor.vehiculos![i];

        if (v.observacion.trim().isNotEmpty) {
          hasObservationOrError = true;
          break;
        }
      }
    } else {
      hasObservationOrError = true;
    }

    return hasObservationOrError;
  }

  Future<void> _checkTravelActive() async {
    try {
      final driverLocationResp =
          await _geofireProvider.getLocationById(_authX.getUser!.uid);
      if (driverLocationResp.exists) {
        final driverLocation =
            driverLocationResp.data() as Map<String, dynamic>;
        if (driverLocation['serviceNow'] != null) {
          // Si es diferente de null es porque tiene un servicio de viaje activo
          Get.offAllNamed(AppRoutes.TRAVEL);
        } else {
          Get.offAllNamed(AppRoutes.MAPA);
        }
      } else {
        Get.offAllNamed(AppRoutes.MAPA);
      }
    } catch (e) {
      Helpers.showError('Hubo un error validando la configuración inicial');
    }
  }

  // Actualización de FCM Token.
  int intervalRetrySeconds = 5;
  final maxAttempts = 8;
  int attempts = 0;
  Future<void> _updateFcmToken() async {
    final fcmToken = NotificationService.token;

    Helpers.logger.wtf(fcmToken);

    if (fcmToken == null) {
      Helpers.logger.e('Error solicitando FCM Token del dispositivo.');
      return;
    }
    while (attempts < maxAttempts) {
      if (_authX.backendUser != null) {
        attempts++;
        final user = _authX.backendUser!;
        try {
          final resp = await _conductorProvider.updateFcmToken(
              user.idConductor, fcmToken);
          if (resp.success) {
            final _updatedDto = _authX.backendUser!.copyWith(fcm: fcmToken);
            _authX.setBackendUser(_updatedDto);
            return;
          }
        } catch (e) {
          Helpers.logger
              .e('No se pudo actualizar FCM Token. Details: ${e.toString()}');
        }
        await Future.delayed(Duration(seconds: intervalRetrySeconds));
      }
    }
  }

  Future<void> _preloadPhoto() async {
    try {
      if (_authX.backendUser != null && _authX.backendUser!.foto != null)
        await precacheImage(
            NetworkImage(
                _authX.backendUser!.foto! + '?v=${_authX.userPhotoVersion}'),
            Get.overlayContext!);
    } catch (e) {
      print('Error en _preloadPhoto');
    }
  }

  // **************************************************
  // * BEGIN::CARGANDO LISTAS MAESTRAS
  // **************************************************
  List<EstadoServicio> _estadosServicio = [];
  int statusToEstadoId(TravelStatus status) {
    int idEstado = 0;
    final reversed = statusValues.reverse?[status];
    final estServ =
        _estadosServicio.firstWhereOrNull((s) => s.code == reversed);
    if (estServ != null) {
      idEstado = estServ.idEstadoServicio;
    } else {
      throw BusinessException(
          'Hubo un problema obteniendo el estado de servicio');
    }
    return idEstado;
  }

  Future<void> _loadMasterLists() async {
    await tryCatch(code: () async {
      final resp =
          await _estadoServicioProvider.getServicios(page: 1, limit: 9999);
      _estadosServicio = resp.content;
      final servicio = (await _servicioProvider.getById(576)).data;
      await _servicioProvider.update(
        servicio.copyWith(
          idEstadoServicio: statusToEstadoId(TravelStatus.CREATED),
        ),
      );
    });
  }
}
