import 'package:animate_do/animate_do.dart';
import 'package:app_driver_ns/data/models/app_type.dart';
import 'package:app_driver_ns/data/models/color_auto.dart';
import 'package:app_driver_ns/data/models/marca.dart';
import 'package:app_driver_ns/data/models/marca_modelo.dart';
import 'package:app_driver_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_driver_ns/modules/cancelacion/cancelacion_controller.dart';
import 'package:app_driver_ns/modules/cancelacion/imagen/cancelacion_imagen_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CancelacionPage extends StatelessWidget {
  final _appX = Get.find<AppPrefsController>();
  final _conX = Get.put(CancelacionController());

  static final cardShadows = [
    BoxShadow(
      color: Color(0xFF8D8B8B).withOpacity(.20),
      blurRadius: 12,
      offset: Offset(0, -6),
    )
  ];

  @override
  Widget build(BuildContext context) {
    _conX.setContext(context);

    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<CancelacionController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Documentos',
              subtitle: 'Cancelacion para brindar servicio',
              enableBack: _conX.enableBack,
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
                            children: [
                              _buildForm(),
                            ],
                          ),
                        ),
                      ),
                      // _buildBottomActions(),
                    ],
                  ),
                ),
              ],
            ),
            _buildSendButton(),
            Obx(() => LoadingOverlay(_conX.loading.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _conX.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: _appX.type == AppType.passenger
                  ? akContentPadding
                  : akContentPadding * 0.5),
          AkText(
            'Datos del vehiculo',
            type: AkTextType.h9,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          _inputMarca(),
          _inputMarkModels(),
          _inputColor(),
          _inputPlaca(),
          SizedBox(height: 10),
          _msgObservacion(),
          _buttonLicenciaConducir(),
          _inputExpLicencia(),
          SizedBox(height: 10),
          _buttonSOAT(),
          _inputExpSoat(),
          SizedBox(height: 10),
          _buttonRevisionTecnica(),
          _inputExpRevision(),
          SizedBox(height: 10),
          _buttonResolucionTaxi(),
          _inputExpResolucion(),
          SizedBox(height: 10),
          _buttonTarjetaCirculacion(),
          _inputExpTarjetaCirculacion(),
          SizedBox(height: 10),
          _buttonAntecedentesPenales(),
          _inputExpAntecedentesPenales(),
          SizedBox(height: 10),
          _buttonAntecedentesJudiciales(),
          _inputExpAntecedentesPoliciales(),
          SizedBox(height: 120.0),
        ],
      ),
    );
  }

  Widget _msgObservacion() {
    return Obx(() => _conX.observacion.value.trim().isNotEmpty
        ? FadeInDown(
            // delay: Duration(milliseconds: 1000),
            duration: Duration(milliseconds: 300),
            from: 50,
            child: Column(
              children: [
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: akSecondaryColor.withOpacity(.10),
                    border: Border.all(color: akSecondaryColor),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: akSecondaryColor,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: akWhiteColor,
                          size: akFontSize + 15.0,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 5.0),
                            AkText(
                              'Observaciones:',
                              style: TextStyle(
                                fontSize: akFontSize + 1.0,
                                color: akTitleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            AkText(
                              _conX.observacion.value,
                              style: TextStyle(fontSize: akFontSize),
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          )
        : SizedBox());
  }

  Widget _inputMarca() {
    return Obx(() => AkInput(
          controller: _conX.marcaCtlr,
          suffixIcon: _conX.loadingMarcas.value
              ? _buildInputLoadIcon()
              : Icon(Icons.unfold_more_rounded),
          enableClean: false,
          maxLength: 30,
          filledColor: Colors.transparent,
          type: AkInputType.underline,
          textCapitalization: TextCapitalization.words,
          hintText: 'Marca',
          labelColor: akTextColor.withOpacity(0.35),
          readOnly: true,
          showCursor: false,
          onTap: () async {
            if (_conX.loadingMarcas.value) return;

            if (_conX.marcas.length == 0) {
              AppSnackbar().info(message: 'No hay elementos que mostrar');
              return;
            }
            final resp = await _showOptions(_conX.marcas);
            if (resp is Marca) {
              _conX.setMarcaSelected(resp);
            } else {
              print('No hubo selección: $resp');
            }
          },
        ));
  }

  Widget _inputMarkModels() {
    return Obx(() => AkInput(
          controller: _conX.markModelsCtlr,
          suffixIcon: _conX.loadingModels.value
              ? _buildInputLoadIcon()
              : Icon(Icons.unfold_more_rounded),
          enableClean: false,
          maxLength: 30,
          filledColor: Colors.transparent,
          type: AkInputType.underline,
          textCapitalization: TextCapitalization.words,
          hintText: 'Modelo',
          labelColor: akTextColor.withOpacity(0.35),
          readOnly: true,
          showCursor: false,
          onTap: () async {
            if (_conX.loadingModels.value) return;

            if (_conX.marcaSelected == null) {
              AppSnackbar().warning(message: 'No se ha seleccionado un marca.');
              return;
            }

            if (_conX.marcaModelos.length == 0) {
              AppSnackbar().info(message: 'No hay elementos que mostrar');
              return;
            }

            final respMarkModels = await _showOptions(_conX.marcaModelos);

            if (respMarkModels is MarcaModelo) {
              _conX.setModeloSelected(respMarkModels);
            } else {
              print('No hubo selección: $respMarkModels');
            }
          },
        ));
  }

  Widget _inputColor() {
    return AkInput(
      controller: _conX.colorCtlr,
      suffixIcon: Icon(Icons.unfold_more_rounded),
      enableClean: false,
      maxLength: 30,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: 'Color',
      labelColor: akTextColor.withOpacity(0.35),
      readOnly: true,
      showCursor: false,
      onTap: () async {
        if (_conX.loading.value) return;

        if (_conX.colors.length == 0) {
          Helpers.snackbar(
              message: 'No hay elementos que mostrar',
              variant: SnackBarVariant.info);
          return;
        }

        final resp = await _showOptions(_conX.colors);
        if (resp is ColorAuto) {
          _conX.setColorSelected(resp);
        } else {
          print('No hubo seleccionón: $resp');
        }
      },
    );
  }

  Widget _inputPlaca() {
    return AkInput(
      controller: _conX.placaCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "###-###",
          filter: {"#": RegExp(r'[a-zA-Z0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Placa de auto',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputExpLicencia() {
    return AkInput(
      controller: _conX.expiracionLicenciaCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "##-##-####",
          filter: {"#": RegExp(r'[0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Fecha de vencimiento de la licencia de conducir',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputExpSoat() {
    return AkInput(
      controller: _conX.expiracionSoatCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "##-##-####",
          filter: {"#": RegExp(r'[0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Fecha de vencimiento de soat',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputExpRevision() {
    return AkInput(
      controller: _conX.expiracionRevisionCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "##-##-####",
          filter: {"#": RegExp(r'[0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Fecha de vencimiento de la revisión técnica',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputExpResolucion() {
    return AkInput(
      controller: _conX.expiracionResolucionCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "##-##-####",
          filter: {"#": RegExp(r'[0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Fecha de vencimiento de la resolucion',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputExpTarjetaCirculacion() {
    return AkInput(
      controller: _conX.expiracionTarjetacirculacionCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "##-##-####",
          filter: {"#": RegExp(r'[0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Fecha de vencimiento de la tarjeta de circulación',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputExpAntecedentesPenales() {
    return AkInput(
      controller: _conX.expiracionPenalesCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "##-##-####",
          filter: {"#": RegExp(r'[0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Fecha de vencimiento de los expedientes penales',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Widget _inputExpAntecedentesPoliciales() {
    return AkInput(
      controller: _conX.expiracionJudicialesCtlr,
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: "##-##-####",
          filter: {"#": RegExp(r'[0-9]')},
        )
      ],
      textCapitalization: TextCapitalization.words,
      hintText: 'Fecha de vencimiento de los expedientes policiales',
      labelColor: akTextColor.withOpacity(0.35),
    );
  }

  Future<dynamic> _showOptions(List<dynamic> items) async {
    List<Widget> options = [];
    for (var item in items) {
      String _text = '';
      if (item is Marca) {
        _text = item.marca;
      }
      if (item is MarcaModelo) {
        _text = item.modelo;
      }
      if (item is ColorAuto) {
        _text = item.color;
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
                item is ColorAuto
                    ? Container(
                        width: 10.0,
                        height: akFontSize + 6.0,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF' + item.codigo)),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      )
                    : SizedBox(),
                item is ColorAuto ? SizedBox(width: 7.0) : SizedBox(),
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

  Widget _buttonLicenciaConducir() {
    String doc = 'Licencia de Conducir';
    return Obx(() => _conX.licenciaConducirSelected.value.isNotEmpty
        ? _FileAttached(
            title: doc,
            img: _conX.licenciaConducirSelected.value,
            isValidated: _conX.valLicenciaConducir,
            onDeleteConfirm: () {
              _conX.licenciaConducirSelected.value = '';
              _conX.valLicenciaConducir = false;
            },
          )
        : AttachButton(
            title: doc,
            onCameraTap: () => _conX.onbuttonLicenciaConducirClick(mode: 1),
            onGalleryTap: () => _conX.onbuttonLicenciaConducirClick(mode: 2),
          ));
  }

  Widget _buttonSOAT() {
    String doc = 'SOAT';
    return Obx(() => _conX.soatSelected.value.isNotEmpty
        ? _FileAttached(
            title: doc,
            img: _conX.soatSelected.value,
            isValidated: _conX.valSoat,
            onDeleteConfirm: () {
              _conX.soatSelected.value = '';
              _conX.valSoat = false;
            },
          )
        : AttachButton(
            title: doc,
            onCameraTap: () => _conX.onbuttonSOATClick(mode: 1),
            onGalleryTap: () => _conX.onbuttonSOATClick(mode: 2),
          ));
  }

  Widget _buttonRevisionTecnica() {
    String doc = 'Revisión técnica';
    return Obx(() => _conX.revisionTecnicaSelected.value.isNotEmpty
        ? _FileAttached(
            title: doc,
            img: _conX.revisionTecnicaSelected.value,
            isValidated: _conX.valRevisionTecnica,
            onDeleteConfirm: () {
              _conX.revisionTecnicaSelected.value = '';
              _conX.valRevisionTecnica = false;
            },
          )
        : AttachButton(
            title: doc,
            onCameraTap: () => _conX.onbuttonRevisionTecnicaClick(mode: 1),
            onGalleryTap: () => _conX.onbuttonRevisionTecnicaClick(mode: 2),
          ));
  }

  Widget _buttonResolucionTaxi() {
    String doc = 'Resolución de taxi';
    return Obx(() => _conX.resoluciontaxiSelected.value.isNotEmpty
        ? _FileAttached(
            title: doc,
            img: _conX.resoluciontaxiSelected.value,
            isValidated: _conX.valResolucionTaxi,
            onDeleteConfirm: () {
              _conX.resoluciontaxiSelected.value = '';
              _conX.valResolucionTaxi = false;
            },
          )
        : AttachButton(
            title: doc,
            onCameraTap: () => _conX.onbuttonResolucionTaxiClick(mode: 1),
            onGalleryTap: () => _conX.onbuttonResolucionTaxiClick(mode: 2),
          ));
  }

  Widget _buttonTarjetaCirculacion() {
    String doc = 'Tarjeta de circulación';
    return Obx(() => _conX.tarjetacirculacionSelected.value.isNotEmpty
        ? _FileAttached(
            title: doc,
            img: _conX.tarjetacirculacionSelected.value,
            isValidated: _conX.valTarjetaCirculacion,
            onDeleteConfirm: () {
              _conX.tarjetacirculacionSelected.value = '';
              _conX.valTarjetaCirculacion = false;
            },
          )
        : AttachButton(
            title: doc,
            onCameraTap: () => _conX.onbuttonTarjetaCirculacionClick(mode: 1),
            onGalleryTap: () => _conX.onbuttonTarjetaCirculacionClick(mode: 2),
          ));
  }

  Widget _buttonAntecedentesPenales() {
    String doc = 'Antecedentes Penales';
    return Obx(() => _conX.antecedentesPenalesSelected.value.isNotEmpty
        ? _FileAttached(
            title: doc,
            img: _conX.antecedentesPenalesSelected.value,
            isValidated: _conX.valAntecedentesPenales,
            onDeleteConfirm: () {
              _conX.antecedentesPenalesSelected.value = '';
              _conX.valAntecedentesPenales = false;
            },
          )
        : AttachButton(
            title: doc,
            onCameraTap: () => _conX.onbuttonAntecedentesPenalesClick(mode: 1),
            onGalleryTap: () => _conX.onbuttonAntecedentesPenalesClick(mode: 2),
          ));
  }

  Widget _buttonAntecedentesJudiciales() {
    String doc = 'Antecedentes Judiciales';
    return Obx(() => _conX.antecedentesPolicialesSelected.value.isNotEmpty
        ? _FileAttached(
            title: doc,
            img: _conX.antecedentesPolicialesSelected.value,
            isValidated: _conX.valAntecedentesPoliciales,
            onDeleteConfirm: () {
              _conX.antecedentesPolicialesSelected.value = '';
              _conX.valAntecedentesPoliciales = false;
            },
          )
        : AttachButton(
            title: doc,
            onCameraTap: () =>
                _conX.onbuttonAntecedentesPolicialesClick(mode: 1),
            onGalleryTap: () =>
                _conX.onbuttonAntecedentesPolicialesClick(mode: 2),
          ));
  }

  Widget _buildSendButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.all(akContentPadding),
        decoration: BoxDecoration(
          color: akScaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
          boxShadow: cardShadows,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AkButton(
              onPressed: _conX.oSendButtonTap,
              text: 'ENVIAR A VALIDACIÓN',
              fluid: true,
              enableMargin: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLoadIcon() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinLoadingIcon(
            color: Colors.black54,
            size: 17.0,
          )
        ],
      ),
    );
  }
}

class _FileAttached extends StatelessWidget {
  final String img;
  final String title;
  final bool isValidated;
  final void Function()? onDeleteConfirm;
  const _FileAttached(
      {Key? key,
      required this.img,
      this.title = '',
      required this.isValidated,
      this.onDeleteConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 8.0,
        top: 8.0,
      ),
      child: Row(
        children: [
          Transform.translate(
            offset: Offset(-6, 0),
            child: Icon(
              Icons.attach_file_rounded,
              color: akTextColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AkText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: akTitleColor,
                    fontSize: akFontSize + 1.0,
                  ),
                ),
                Row(
                  children: [
                    AkText(
                      isValidated ? 'Validado' : 'Validación pendiente',
                      style: TextStyle(
                        fontSize: akFontSize - 1.0,
                        color: isValidated
                            ? akSuccessColor
                            : akTitleColor.withOpacity(.50),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Icon(
                      isValidated
                          ? Icons.check_circle_outline_rounded
                          : Icons.timelapse_sharp,
                      color: isValidated
                          ? akSuccessColor
                          : akTitleColor.withOpacity(.30),
                      size: akFontSize,
                    ),
                  ],
                )
              ],
            ),
          ),
          AkButton(
            backgroundColor: Helpers.darken(akScaffoldBackgroundColor, 0.02),
            contentPadding: EdgeInsets.all(7.0),
            child: Icon(Icons.more_vert_rounded),
            onPressed: () async {
              final resp = await Get.dialog(
                  AlertDialog(
                    contentPadding: EdgeInsets.all(0.0),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    content: Container(
                      width: 1000.0,
                      constraints:
                          BoxConstraints(minHeight: 10.0, maxHeight: 300.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(akRadiusGeneral)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AkText(
                            'Opciones',
                            style: TextStyle(
                                fontSize: akFontSize + 2.0,
                                fontWeight: FontWeight.w500,
                                color: akTitleColor),
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: AkButton(
                                  backgroundColor: Helpers.darken(
                                      akScaffoldBackgroundColor, 0.02),
                                  textColor: akPrimaryColor,
                                  onPressed: () {
                                    Get.back(result: 1);
                                  },
                                  text: 'Ver',
                                  fluid: true,
                                  enableMargin: false,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: AkButton(
                                variant: AkButtonVariant.red,
                                onPressed: () {
                                  Get.back(result: 2);
                                },
                                text: 'Eliminar',
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
                Get.toNamed(AppRoutes.REQUISITOS_IMAGEN,
                    arguments: CancelacionImagenArguments(
                      title: title,
                      imageB64orUrl: img,
                    ));
              }

              if (resp == 2) {
                final confirmDelete = await Get.dialog(
                    AlertDialog(
                      contentPadding: EdgeInsets.all(0.0),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      content: Container(
                        width: 1000.0,
                        constraints:
                            BoxConstraints(minHeight: 10.0, maxHeight: 300.0),
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(akRadiusGeneral)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                AkText(
                                  '¿Estás seguro que deseas eliminar el archivo?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: akFontSize + 1.0,
                                      fontWeight: FontWeight.w500,
                                      color: akTitleColor),
                                ),
                                SizedBox(height: 10.0),
                                AkText(
                                  'Esta acción se confirmará cuando se guarden los cambios.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: akFontSize + 1.0,
                                      color: akTitleColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: AkButton(
                                  backgroundColor: Helpers.darken(
                                      akScaffoldBackgroundColor, 0.02),
                                  textColor: akPrimaryColor,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text: 'Cancelar',
                                  fluid: true,
                                  enableMargin: false,
                                )),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: AkButton(
                                    variant: AkButtonVariant.red,
                                    onPressed: () {
                                      Get.back(result: true);
                                    },
                                    text: 'Sí, eliminar',
                                    fluid: true,
                                    enableMargin: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    barrierColor: Colors.black.withOpacity(0.35));

                if (confirmDelete == true) {
                  onDeleteConfirm?.call();
                }
              }
            },
            text: title,
            enableMargin: false,
          )
        ],
      ),
    );
  }
}
