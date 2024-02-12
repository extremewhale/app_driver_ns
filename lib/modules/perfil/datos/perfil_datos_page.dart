import 'package:app_driver_ns/data/models/app_type.dart';
import 'package:app_driver_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/perfil/datos/perfil_datos_controller.dart';
import 'package:app_driver_ns/modules/requisitos/imagen/requisitos_imagen_controller.dart';
import 'package:app_driver_ns/modules/requisitos/requisitos_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilDatosPage extends StatelessWidget {
  final _appX = Get.find<AppPrefsController>();
  final _auth = Get.find<AuthController>();
  final _conX = Get.put(PerfilDatosController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<PerfilDatosController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Mis datos',
              subtitle: 'Datos personales del conductor',
              onBack: () async {
                if (await _conX.handleBack()) Get.back();
              },
              children: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Content(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: _appX.type == AppType.passenger
                                    ? akContentPadding
                                    : 0.0,
                              ),
                              GetBuilder<PerfilDatosController>(
                                id: _conX.gbPhoto,
                                builder: (_) => _HeaderPhotoName(
                                  auth: _auth,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              StylusCard(
                                title: 'PERSONAL',
                                items: [
                                  StylusCardItem(
                                    icon: Icons.camera_alt_rounded,
                                    text: 'Cambiar foto de perfil',
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
                                    icon: Icons.mail_rounded,
                                    text: _auth.getUser?.email,
                                    textOverflow: TextOverflow.ellipsis,
                                    onTap: _conX.onEmailChangeTap,
                                  ),
                                  StylusCardItem(
                                    icon: Icons.lock_rounded,
                                    text: 'Cambiar contraseña',
                                    onTap: _conX.onButtonPasswordChangeTap,
                                  ),
                                ],
                              ),
                              StylusCard(
                                title: 'LICENCIA',
                                items: [
                                  StylusCardItem(
                                    icon: Icons.document_scanner_rounded,
                                    text: 'Licencia de conducir',
                                    onTap: () {
                                      Get.toNamed(AppRoutes.PERFIL_LICENCIA);
                                    },
                                  ),
                                ],
                              ),
                              StylusCard(
                                title: 'DOCUMENTOS',
                                items: [
                                  StylusCardItem(
                                    icon: Icons.document_scanner_rounded,
                                    text: 'Actualizar info de auto',
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes.REQUISITOS,
                                        arguments: RequisitosArguments(
                                          enableBack: true,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              /* StylusCard(
                                title: 'CALIFICACIÓN',
                                items: [
                                  StylusCardItem(
                                    icon: Icons.star_rate_rounded,
                                    text: 'Mi calificación',
                                  ),
                                ],
                              ), */
                              StylusCard(
                                title: 'APLICACIÓN',
                                items: [
                                  /* StylusCardItem(
                                    icon: Icons.settings_rounded,
                                    text: 'Preferencias',
                                  ), */
                                  StylusCardItem(
                                    icon: Icons.logout_rounded,
                                    text: 'Cerrar sesión',
                                    onTap: () {
                                      _auth.logout();
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
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

class _HeaderPhotoName extends StatelessWidget {
  final AuthController auth;

  _HeaderPhotoName({
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
                if (auth.backendUser?.foto != null) {
                  Get.toNamed(AppRoutes.REQUISITOS_IMAGEN,
                      arguments: RequisitosImagenArguments(
                        title: 'Foto de perfil',
                        imageB64orUrl: auth.backendUser!.foto! +
                            '?v=${auth.userPhotoVersion}',
                      ));
                }
              },
              child: PhotoUser(
                avatarUrl: auth.backendUser?.foto ?? '',
                photoVersion: auth.userPhotoVersion,
                size: Get.width * 0.20,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        AkText(
          Helpers.nameFormatCase((auth.backendUser?.nombres ?? '') +
              ' ' +
              (auth.backendUser?.apellidos ?? '')),
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
