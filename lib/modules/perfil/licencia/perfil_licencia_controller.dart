import 'package:app_driver_ns/data/models/conductor.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/mapa/mapa_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilLicenciaController extends GetxController {
  late PerfilLicenciaController _self;
  late ScrollController scrollController;

  final _authX = Get.find<AuthController>();

  final _conductorProvider = ConductorProvider();

  final gbAppbar = 'gbAppbar';
  final loading = false.obs;

  final formKey = GlobalKey<FormState>();
  final licenciaCtlr = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    _init();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _init() {
    final _currentUser = _authX.backendUser!;
    licenciaCtlr.text = _currentUser.licencia ?? '';
  }

  void onNextClicked() async {
    if (loading.value) return; // No eliminar

    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      final licencia = licenciaCtlr.text.trim();
      _updateLicenseData(licencia);
    }
  }

  Future<void> _updateLicenseData(String licenciaConducir) async {
    String? errorMsg;
    ConductorDto? _updatedUser;
    try {
      loading.value = true;
      final _oldUser = _authX.backendUser!;
      _updatedUser = _oldUser.copyWith(licencia: licenciaConducir);
      await _conductorProvider.update(_updatedUser.idConductor, _updatedUser);
    } on ApiException catch (e) {
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
        _updateLicenseData(licenciaConducir);
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;
      // Actualiza el backendUser de Auth
      _authX.setBackendUser(_updatedUser!);
      AppSnackbar().success(message: 'Datos actualizados');

      // Verifica que el perfil esté completo
      final _tmpMapaX = Get.find<MapaController>();
      _tmpMapaX.verifyProfileData();
    }
  }

  String? validateLicencia(String? text) {
    if (text != null && text.trim().length >= 6) {
      return null;
    }
    return 'Campo requerido';
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }
}
