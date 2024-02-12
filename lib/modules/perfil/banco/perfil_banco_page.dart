import 'package:app_driver_ns/data/models/banco.dart';
import 'package:app_driver_ns/modules/perfil/banco/perfil_banco_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilBancoPage extends StatelessWidget {
  final _conX = Get.put(PerfilBancoController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<PerfilBancoController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              title: 'Cuenta bancaria',
              subtitle: 'Todo lo referente a tu cuenta bancaria',
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
                                _titleInput('Banco'),
                                _inputBanco(),
                                SizedBox(height: 20.0),
                                _titleInput('Número de cuenta'),
                                _inputCtaBancaria(),
                                SizedBox(height: 20.0),
                                _titleInput('Cuenta Interbancaria (CCI)'),
                                _inputCtaCCI(),
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

  Widget _inputBanco() {
    return AkInput(
      controller: _conX.bancoCtlr,
      suffixIcon: Icon(Icons.unfold_more_rounded),
      enableClean: false,
      maxLength: 30,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: 'Banco',
      labelColor: akTextColor.withOpacity(0.35),
      readOnly: true,
      showCursor: false,
      validator: _conX.validateBanco,
      onTap: () async {
        if (_conX.loading.value) return;

        if (_conX.bancos.length == 0) {
          Helpers.snackbar(
              message: 'No hay elementos que mostrar',
              variant: SnackBarVariant.info);
          return;
        }

        final resp = await _showOptions(_conX.bancos);
        if (resp is Banco) {
          _conX.setBancoSelected(resp);
        } else {
          print('No hubo seleccionón: $resp');
        }
      },
    );
  }

  Future<dynamic> _showOptions(List<dynamic> items) async {
    List<Widget> options = [];
    for (var item in items) {
      String _text = '';
      if (item is Banco) {
        _text = item.nombre;
      }
      options.add(Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () => Get.back(result: item),
          highlightColor: Colors.transparent,
          splashColor: akPrimaryColor,
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: AkText('$_text'),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    final ScrollController controller = ScrollController();

    final resp = await Get.dialog(
        AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            width: 1000.0,
            constraints: BoxConstraints(minHeight: 10.0, maxHeight: 300.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(akRadiusGeneral)),
            child: Theme(
              data: Theme.of(Get.context!).copyWith(
                highlightColor: akPrimaryColor,
              ),
              child: Scrollbar(
                radius: Radius.circular(30.0),
                thickness: 5.0,
                thumbVisibility: true,
                controller: controller,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  physics: BouncingScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (c, idx) {
                    return options[idx];
                  },
                ),
              ),
            ),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.35));
    return resp;
  }

  Widget _inputCtaBancaria() {
    return AkInput(
      controller: _conX.nroCtaCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      hintText: 'Número de cuenta',
      validator: _conX.validateCtaAndCCI,
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputCtaCCI() {
    return AkInput(
      controller: _conX.nroCtaCCICtlr,
      enableClean: false,
      maxLength: 100,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      hintText: 'Cuenta Interbancaria (CCI)',
      validator: _conX.validateCtaAndCCI,
      labelColor: akTextColor.withOpacity(0.35),
      // onSaved: (text) => _conX.apellido = text!.trim(),
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
