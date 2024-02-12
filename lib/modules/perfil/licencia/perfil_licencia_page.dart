import 'package:app_driver_ns/modules/perfil/licencia/perfil_licencia_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilLicenciaPage extends StatelessWidget {
  final _conX = Get.put(PerfilLicenciaController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<PerfilLicenciaController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              title: 'Lic. de conducir',
              subtitle: 'Todo lo referente a tu licencia de conducir',
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
                          child: Form(
                            key: _conX.formKey,
                            child: Column(
                              children: [
                                _titleInput('Número de licencia'),
                                _inputLicencia(),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(akContentPadding),
                        child: AkButton(
                          fluid: true,
                          enableMargin: false,
                          onPressed: _conX.onNextClicked,
                          text: 'Guardar',
                        ),
                      )
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

  Widget _inputLicencia() {
    return AkInput(
      controller: _conX.licenciaCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      hintText: 'Número de licencia',
      validator: _conX.validateLicencia,
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _titleInput(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(width: 8.0),
            Expanded(
              child: AkText(
                title,
                style: TextStyle(
                  color: akTitleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: akFontSize + 1.0,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
