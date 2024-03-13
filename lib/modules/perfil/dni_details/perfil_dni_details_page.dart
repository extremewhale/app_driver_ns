import 'package:app_driver_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/perfil/dni_details/perfil_dni_details_controller.dart';
import 'package:app_driver_ns/modules/requisitos/imagen/requisitos_imagen_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilDniDetailsPage extends StatelessWidget {
  final _auth = Get.find<AuthController>();
  final _appX = Get.find<AppPrefsController>();
  final _conX = Get.put(PerfilDniDetailsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<PerfilDniDetailsController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Dni',
              subtitle: 'Fotos del dni del conductor',
              onBack: () async {
                if (await _conX.handleBack()) Get.back();
              },
              children: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: Content(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: akContentPadding),
                              GetBuilder<PerfilDniDetailsController>(
                                id: _conX.gbDni,
                                builder: (_) => _HeaderDni(
                                  auth: _auth,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              GetBuilder<PerfilDniDetailsController>(
                                id: _conX.gbDniReverso,
                                builder: (_) => _HeaderDniReverso(
                                  auth: _auth,
                                ),
                              ),
                              StylusCard(
                                title: 'Actualizar',
                                items: [
                                  StylusCardItem(
                                    icon: Icons.camera_alt_rounded,
                                    text: 'Cambiar foto de dni',
                                    onTap: () {
                                      _showDialogPhoto(
                                        onCameraTap: () => _conX
                                            .onUserSelectUploadPhoto(mode: 1),
                                        onGalleryTap: () => _conX
                                            .onUserSelectUploadPhoto(mode: 2),
                                      );
                                    },
                                  ),
                                  StylusCardItem(
                                    icon: Icons.camera_alt_rounded,
                                    text: 'Cambiar foto de dni Reverso',
                                    onTap: () {
                                      _showDialogPhoto(
                                        onCameraTap: () =>
                                            _conX.onUserSelectUploadDniReverse(
                                                mode: 1),
                                        onGalleryTap: () =>
                                            _conX.onUserSelectUploadDniReverse(
                                                mode: 2),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => LoadingOverlay(_conX.loading.value)),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialogPhoto({
    VoidCallback? onCameraTap,
    VoidCallback? onGalleryTap,
  }) async {
    final resp = await Get.dialog(
        AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            width: 1000.0,
            constraints: BoxConstraints(minHeight: 10.0, maxHeight: 300.0),
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(akRadiusGeneral)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AkText('Selecciona alguna de estas opciones:'),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: AkButton(
                      onPressed: () {
                        Get.back(result: 1);
                      },
                      text: 'Cámara',
                      fluid: true,
                      enableMargin: false,
                    )),
                    SizedBox(width: 10.0),
                    Expanded(
                        child: AkButton(
                      onPressed: () {
                        Get.back(result: 2);
                      },
                      text: 'Galeria',
                      fluid: true,
                      enableMargin: false,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.35));

    if (resp == 1) {
      onCameraTap?.call();
    } else if (resp == 2) {
      onGalleryTap?.call();
    }
  }
}

class _HeaderDni extends StatelessWidget {
  final AuthController auth;

  _HeaderDni({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (auth.backendUser?.dni != null) {
                  Get.toNamed(AppRoutes.REQUISITOS_IMAGEN,
                      arguments: RequisitosImagenArguments(
                        title: 'Foto de dni',
                        imageB64orUrl: auth.backendUser!.dni! +
                            '?v=${auth.userPhotoVersion}',
                      ));
                }
              },
              child: PhotoUser(
                avatarUrl: auth.backendUser?.dni ?? '',
                photoVersion: auth.userPhotoVersion,
                size: Get.width * 0.20,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        AkText(
          Helpers.nameFormatCase('Foto de Dni'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: akTitleColor,
            fontSize: akFontSize + 5.0,
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }
}

class _HeaderDniReverso extends StatelessWidget {
  final AuthController auth;

  _HeaderDniReverso({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (auth.backendUser?.dniReverso != null) {
                  Get.toNamed(AppRoutes.REQUISITOS_IMAGEN,
                      arguments: RequisitosImagenArguments(
                        title: 'Foto de dni reverso',
                        imageB64orUrl: auth.backendUser!.dniReverso! +
                            '?v=${auth.userPhotoVersion}',
                      ));
                }
              },
              child: PhotoUser(
                avatarUrl: auth.backendUser?.dniReverso ?? '',
                photoVersion: auth.userPhotoVersion,
                size: Get.width * 0.20,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        AkText(
          Helpers.nameFormatCase('Foto de DNI REVERSO'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: akTitleColor,
            fontSize: akFontSize + 5.0,
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }
}
