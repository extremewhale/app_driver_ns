import 'package:app_driver_ns/data/models/banco.dart';
import 'package:app_driver_ns/data/models/conductor.dart';
import 'package:app_driver_ns/data/providers/banco_provider.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/mapa/mapa_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilBancoController extends GetxController {
  late PerfilBancoController _self;
  late ScrollController scrollController;

  final _authX = Get.find<AuthController>();

  final _bancoProvider = BancoProvider();
  final _conductorProvider = ConductorProvider();

  final gbAppbar = 'gbAppbar';

  final loading = false.obs;

  final bancoCtlr = TextEditingController();
  final nroCtaCtlr = TextEditingController();
  final nroCtaCCICtlr = TextEditingController();

  Banco? bancoSelected;

  List<Banco> _bancos = [];
  List get bancos => this._bancos;

  final formKey = GlobalKey<FormState>();

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
    _loadBancos();
  }

  Future<void> _loadBancos() async {
    String? errorMsg;
    try {
      loading.value = true;
      this._bancos = [];
      final res = await _bancoProvider.getAll(limit: 999, page: 1);
      this._bancos = res.content;
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
        _loadBancos();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;

      final _currentUser = _authX.backendUser!;
      final filter = this
          ._bancos
          .firstWhereOrNull((c) => c.idBanco == _currentUser.idBanco);
      if (filter != null) setBancoSelected(filter);

      nroCtaCtlr.text = _currentUser.numeroCuenta ?? '';
      nroCtaCCICtlr.text = _currentUser.numeroCuentaInterbancaria ?? '';
    }
  }

  void onNextClicked() async {
    if (loading.value) return; // No eliminar

    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      final cta = nroCtaCtlr.text.trim().replaceAll(new RegExp(r'[^0-9]'), '');
      final ctaCCI =
          nroCtaCCICtlr.text.trim().replaceAll(new RegExp(r'[^0-9]'), '');

      _updateBancoData(bancoSelected!.idBanco, cta, ctaCCI);
    }
  }

  Future<void> _updateBancoData(int idBanco, String cta, String ctaCCI) async {
    String? errorMsg;
    ConductorDto? _updatedUser;
    try {
      loading.value = true;
      final _oldUser = _authX.backendUser!;
      _updatedUser = _oldUser.copyWith(
        idBanco: idBanco,
        numeroCuenta: cta,
        numeroCuentaInterbancaria: ctaCCI,
      );
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
        _updateBancoData(idBanco, cta, ctaCCI);
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

  void setBancoSelected(Banco banco) {
    bancoCtlr.text = banco.nombre;
    bancoSelected = banco;
  }

  String? validateBanco(String? text) {
    if (bancoSelected != null) {
      return null;
    }
    return 'Campo requerido';
  }

  String? validateCtaAndCCI(String? text) {
    if (text != null) {
      final extractNumber = text.trim().replaceAll(new RegExp(r'[^0-9]'), '');
      if (extractNumber.isNumericOnly && extractNumber.length >= 5) {
        return null;
      } else {
        return 'Número no válido';
      }
    }

    return 'Campo requerido';
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }
}
