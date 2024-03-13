import 'dart:convert';

import 'package:app_driver_ns/data/models/conductor.dart';
import 'package:app_driver_ns/data/models/repositorio.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/data/providers/repositorio_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/mapa/mapa_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PerfilDniDetailsController extends GetxController
    with WidgetsBindingObserver {
  late PerfilDniDetailsController _self;
  late ScrollController scrollController;
  final _authX = Get.find<AuthController>();
  final _repositorioProvider = RepositorioProvider();
  final _conductorProvider = ConductorProvider();
  final loading = false.obs;
  final gbAppbar = 'gbAppbar';
  final gbDni = 'gbDni';
  final gbDniReverso = 'gbDniReverso';

  @override
  void onInit() {
    super.onInit();
    this._self = this;
    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    WidgetsBinding.instance?.addObserver(this);
  }

  late PickedFile? imageFile;
  Future getImage(int type) async {
    // ignore: deprecated_member_use
    PickedFile? pickedImage = await ImagePicker().getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  void onUserSelectUploadPhoto({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      _uploadDniPhoto(base64Image);
    }
  }

  Future<void> _uploadDniPhoto(String base64Image) async {
    String? errorMsg;
    RepositorioResponse? resp;
    try {
      loading.value = true;
      resp = await _repositorioProvider.sendFileBase64(
        fileName: 'photo_dni_conductor_${_authX.backendUser?.idConductor}.png',
        base64: base64Image,
      );
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
        _uploadDniPhoto(base64Image);
      } else {
        loading.value = false;
      }
    } else {
      _updateDNIConductor(resp!.url);
    }
  }

  Future<void> _updateDNIConductor(String photoUrl) async {
    String? errorMsg;
    // RepositorioResponse? resp;
    ConductorDto? _updatedUser;
    try {
      loading.value = true;
      final _oldUser = _authX.backendUser;
      _updatedUser = _oldUser!.copyWith(dni: photoUrl);
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
        _updateDNIConductor(photoUrl);
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;
      // Actualiza el backendUser de Auth
      _authX.setBackendUser(_updatedUser!);

      update([gbDni]);

      AppSnackbar().success(message: 'Dni actualizado');

      // Verifica que el perfil esté completo
      final _tmpMapaX = Get.find<MapaController>();
      _tmpMapaX.verifyProfileData();
    }
  }

  void onUserSelectUploadDniReverse({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      _uploadDniReversePhoto(base64Image);
    }
  }

  Future<void> _uploadDniReversePhoto(String base64Image) async {
    String? errorMsg;
    RepositorioResponse? resp;
    try {
      loading.value = true;
      resp = await _repositorioProvider.sendFileBase64(
        fileName:
            'photo_dni_reverse_conductor_${_authX.backendUser?.idConductor}.png',
        base64: base64Image,
      );
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
        _uploadDniReversePhoto(base64Image);
      } else {
        loading.value = false;
      }
    } else {
      _updateDNIReverseConductor(resp!.url);
    }
  }

  Future<void> _updateDNIReverseConductor(String photoUrl) async {
    String? errorMsg;
    // RepositorioResponse? resp;
    ConductorDto? _updatedUser;
    try {
      loading.value = true;
      final _oldUser = _authX.backendUser;
      _updatedUser = _oldUser!.copyWith(dniReverso: photoUrl);
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
        _updateDNIReverseConductor(photoUrl);
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;
      // Actualiza el backendUser de Auth
      _authX.setBackendUser(_updatedUser!);

      update([gbDniReverso]);

      AppSnackbar().success(message: 'Dni Reverso actualizado');

      // Verifica que el perfil esté completo
      final _tmpMapaX = Get.find<MapaController>();
      _tmpMapaX.verifyProfileData();
    }
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }
}
