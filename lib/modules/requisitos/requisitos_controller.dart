import 'dart:convert';
import 'dart:math';

import 'package:app_driver_ns/data/models/color_auto.dart';
import 'package:app_driver_ns/data/models/marca.dart';
import 'package:app_driver_ns/data/models/marca_modelo.dart';
import 'package:app_driver_ns/data/models/vehiculo.dart';
import 'package:app_driver_ns/data/providers/color_auto_provider.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/data/providers/marca_provider.dart';
import 'package:app_driver_ns/data/providers/repositorio_provider.dart';
import 'package:app_driver_ns/data/providers/vehiculo_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

enum _AccionVehiculo { create, update }

class RequisitosController extends GetxController {
  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  late RequisitosController _self;
  late BuildContext _context;

  final _authX = Get.find<AuthController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final marcaCtlr = TextEditingController();
  final markModelsCtlr = TextEditingController();
  final colorCtlr = TextEditingController();
  final placaCtlr = TextEditingController();

  final _marcaProvider = MarcaProvider();
  final _colorAutoProvider = ColorAutoProvider();
  final _repositorioProvider = RepositorioProvider();
  final _conductorProvider = ConductorProvider();
  final _vehiculoProvider = VehiculoProvider();

  bool enableBack = false;
  bool shoWelcomeDialog = false;
  bool showFixDocuments = false;

  final loading = false.obs;

  final loadingMarcas = false.obs;
  final loadingModels = false.obs;

  List<Marca> _marcas = [];
  List get marcas => this._marcas;

  List<MarcaModelo> _marcaModelos = [];
  List get marcaModelos => this._marcaModelos;

  List<ColorAuto> _colors = [];
  List get colors => this._colors;

  Marca? marcaSelected;
  MarcaModelo? marcaModeloSelected;
  ColorAuto? colorSelected;

  final licenciaConducirSelected = ''.obs;
  final soatSelected = ''.obs;
  final revisionTecnicaSelected = ''.obs;
  final resoluciontaxiSelected = ''.obs;
  final tarjetacirculacionSelected = ''.obs;

  final antecedentesPenalesSelected = ''.obs;
  final antecedentesPolicialesSelected = ''.obs;

  bool valLicenciaConducir = false;
  bool valSoat = false;
  bool valRevisionTecnica = false;
  bool valResolucionTaxi = false;
  bool valTarjetaCirculacion = false;

  bool valAntecedentesPenales = false;
  bool valAntecedentesPoliciales = false;

  final expiracionLicenciaCtlr = TextEditingController();
  final expiracionSoatCtlr = TextEditingController();
  final expiracionRevisionCtlr = TextEditingController();
  final expiracionResolucionCtlr = TextEditingController();
  final expiracionTarjetacirculacionCtlr = TextEditingController();

  final expiracionPenalesCtlr = TextEditingController();
  final expiracionJudicialesCtlr = TextEditingController();

  String expiracionLicencia = '';
  String expiracionSoat = '';
  String expiracionRevision = '';
  String expiracionResolucion = '';
  String expiracionTarjetacirculacion = '';

  String expiracionPenales = '';
  String expiracionJudiciales = '';

  final observacion = ''.obs;

  _AccionVehiculo accion = _AccionVehiculo.create;
  Vehiculo? vehiculo;

  @override
  void onInit() {
    super.onInit();
    _self = this;

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    this._init();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void setContext(BuildContext c) {
    this._context = c;
  }

  Future<void> _init() async {
    if (!(Get.arguments is RequisitosArguments)) {
      Helpers.showError('Falta pasar los argumentos');
      return;
    }

    final arguments = Get.arguments as RequisitosArguments;
    enableBack = arguments.enableBack;
    shoWelcomeDialog = arguments.shoWelcomeDialog;
    showFixDocuments = arguments.showFixDocuments;

    await _getData();
  }

  Future<void> _getData() async {
    String? errorMsg;
    try {
      loading.value = true;
      final resp =
          await _conductorProvider.getById(_authX.backendUser!.idConductor);
      // En ese punto vehículos debe ser diferente de null si o si
      if (resp.data.vehiculos!.isNotEmpty) {
        accion = _AccionVehiculo.update;
        vehiculo = resp.data.vehiculos!.first;
      } else {
        accion = _AccionVehiculo.create;
      }
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
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
        _getData();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;

      if (accion == _AccionVehiculo.update) {
        placaCtlr.text = vehiculo!.placa;

        observacion.value = vehiculo!.observacion;
        licenciaConducirSelected.value = vehiculo?.urlLicenciaConducir ?? '';
        valLicenciaConducir = vehiculo!.valLicenciaConducir;

        soatSelected.value = vehiculo?.urlSoat ?? '';
        valSoat = vehiculo!.valSoat;

        revisionTecnicaSelected.value = vehiculo?.urlRevisionTecnica ?? '';
        valRevisionTecnica = vehiculo!.valRevisionTecnica;

        resoluciontaxiSelected.value = vehiculo?.urlResolucionTaxi ?? '';
        valResolucionTaxi = vehiculo!.valResolucionTaxi;

        tarjetacirculacionSelected.value =
            vehiculo?.urlTarjetaCirculacion ?? '';
        valTarjetaCirculacion = vehiculo!.valTarjetaCirculacion;

        antecedentesPenalesSelected.value =
            vehiculo?.urlAntecedentesPenales ?? '';
        valAntecedentesPenales = vehiculo!.valAntecedentesPenales;

        antecedentesPolicialesSelected.value =
            vehiculo?.urlAntecedentesPoliciales ?? '';
        valAntecedentesPoliciales = vehiculo!.valAntecedentesPoliciales;

        var expiracionLicencia = vehiculo!.expiracionLicencia ?? '01-01-2022';
        expiracionLicenciaCtlr.text = DateFormat('dd-MM-yyyy')
            .format(new DateFormat("yyyy-MM-dd").parse(expiracionLicencia));

        var expiracionSoat = vehiculo!.expiracionSoat ?? '01-01-2022';
        expiracionSoatCtlr.text = DateFormat('dd-MM-yyyy')
            .format(new DateFormat("yyyy-MM-dd").parse(expiracionSoat));

        var expiracionRevision = vehiculo!.expiracionRevision ?? '01-01-2022';
        expiracionRevisionCtlr.text = DateFormat('dd-MM-yyyy')
            .format(new DateFormat("yyyy-MM-dd").parse(expiracionRevision));

        var expiracionResolucion =
            vehiculo!.expiracionResolucion ?? '01-01-2022';
        expiracionResolucionCtlr.text = DateFormat('dd-MM-yyyy')
            .format(new DateFormat("yyyy-MM-dd").parse(expiracionResolucion));

        var expiracionTarjetacirculacion =
            vehiculo!.expiracionTarjetacirculacion ?? '01-01-2022';
        expiracionTarjetacirculacionCtlr.text = DateFormat('dd-MM-yyyy').format(
            new DateFormat("yyyy-MM-dd").parse(expiracionTarjetacirculacion));

        var expiracionPenales = vehiculo!.expiracionPenales ?? '01-01-2022';
        expiracionPenalesCtlr.text = DateFormat('dd-MM-yyyy')
            .format(new DateFormat("yyyy-MM-dd").parse(expiracionPenales));

        var expiracionJudiciales =
            vehiculo!.expiracionJudiciales ?? '01-01-2022';
        expiracionJudicialesCtlr.text = DateFormat('dd-MM-yyyy')
            .format(new DateFormat("yyyy-MM-dd").parse(expiracionJudiciales));
      }

      this._loadColors();
    }
  }

  Future<void> _loadColors() async {
    String? errorMsg;
    try {
      loading.value = true;
      this._colors = [];
      final res = await _colorAutoProvider.getAllColors(limit: 999, page: 1);
      this._colors = res.content;
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
        _loadColors();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;

      if (accion == _AccionVehiculo.update) {
        final filter = this
            ._colors
            .firstWhereOrNull((c) => c.idColor == vehiculo?.idColor);
        if (filter != null) setColorSelected(filter);
      }

      _loadMarks();
    }
  }

  Future<void> _loadMarks() async {
    loading.value = true;
    loadingMarcas.value = true;

    String? errorMsg;
    try {
      this._marcas = [];
      final res = await _marcaProvider.getAllMarcas(limit: 999, page: 1);
      this._marcas = res.content;
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
        _loadMarks();
      } else {
        loading.value = false;
        loadingMarcas.value = false;
      }
    } else {
      loading.value = false;
      loadingMarcas.value = false;

      if (accion == _AccionVehiculo.update) {
        final filter = this
            ._marcas
            .firstWhereOrNull((c) => c.idMarca == vehiculo?.idMarca);
        if (filter != null) setMarcaSelected(filter);
      }

      // Después que se cargaron los inputs.. muestro la alerta
      if (shoWelcomeDialog) {
        _launchModalWelcomeOrAdvice(_context, true);
      } else if (showFixDocuments) {
        _launchModalWelcomeOrAdvice(_context, false);
      }
    }
  }

  bool isFirstSelectModelo = true;
  void _loadMarkModels({required int idMarca}) async {
    loadingModels.value = true;

    String? errorMsg;
    try {
      this._marcaModelos = [];
      final res = await _marcaProvider.getAllModels4Mark(idMarca: idMarca);
      this._marcaModelos = res.data.modelos;
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
        _loadMarkModels(idMarca: idMarca);
      } else {
        loadingModels.value = false;
        Get.back();
      }
    } else {
      loadingModels.value = false;

      if (accion == _AccionVehiculo.update) {
        // No aseguramos que se autocomplete solo en la primera carga
        if (isFirstSelectModelo) {
          isFirstSelectModelo = false;
          final filter = this
              ._marcaModelos
              .firstWhereOrNull((c) => c.idModelo == vehiculo?.idModelo);
          if (filter != null) setModeloSelected(filter);
        }
      }
    }
  }

  void onbuttonLicenciaConducirClick({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      this.licenciaConducirSelected.value = base64Image;
    }
  }

  void onbuttonSOATClick({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      this.soatSelected.value = base64Image;
    }
  }

  void onbuttonRevisionTecnicaClick({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      this.revisionTecnicaSelected.value = base64Image;
    }
  }

  void onbuttonResolucionTaxiClick({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      this.resoluciontaxiSelected.value = base64Image;
    }
  }

  void onbuttonTarjetaCirculacionClick({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      this.tarjetacirculacionSelected.value = base64Image;
    }
  }

  void onbuttonAntecedentesPenalesClick({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      this.antecedentesPenalesSelected.value = base64Image;
    }
  }

  void onbuttonAntecedentesPolicialesClick({required int mode}) async {
    imageFile = await getImage(mode);
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      this.antecedentesPolicialesSelected.value = base64Image;
    }
  }

  late PickedFile? imageFile;
  Future getImage(int type) async {
    // ignore: deprecated_member_use
    PickedFile? pickedImage = await ImagePicker().getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  void oSendButtonTap() async {
    if (marcaSelected == null) {
      AppSnackbar().warning(message: 'No ha seleccionado una marca.');
      return;
    }

    if (marcaModeloSelected == null) {
      AppSnackbar().warning(message: 'No ha seleccionado un modelo.');
      return;
    }

    if (colorSelected == null) {
      AppSnackbar().warning(message: 'No ha seleccionado un color.');
      return;
    }

    if (validatePlaca() != null) {
      AppSnackbar().warning(message: validatePlaca() ?? '');
      return;
    }

    if (licenciaConducirSelected.value == '') {
      AppSnackbar().warning(message: 'No se adjuntó la licencia de conducir');
      return;
    }

    if (soatSelected.value == '') {
      AppSnackbar().warning(message: 'No se adjuntó el SOAT.');
      return;
    }

    if (revisionTecnicaSelected.value == '') {
      AppSnackbar().warning(message: 'No se adjuntó la revisión técnica.');
      return;
    }

    if (resoluciontaxiSelected.value == '') {
      AppSnackbar().warning(message: 'No se adjuntó la resolución de taxi.');
      return;
    }

    if (tarjetacirculacionSelected.value == '') {
      AppSnackbar()
          .warning(message: 'No se adjunto la tarjeta de circulación.');
      return;
    }

    loading.value = true;
    String? errorMsg;
    try {
      String urlLicenciaConducir = '';
      String urlSoat = '';
      String urlRevisionTecnica = '';
      String urlResoluciontaxi = '';
      String urlTarjetacirculacion = '';

      String urlantecedentesPenales = '';
      String urlantecedentesPoliciales = '';

      var _filename = '';

      if (!licenciaConducirSelected.value.isURL) {
        _filename = 'licenciaconducir.jpg';
        final resLicenciaConducir = await _repositorioProvider.sendFileBase64(
            fileName: _filename, base64: licenciaConducirSelected.value);
        urlLicenciaConducir = resLicenciaConducir.url;
      } else {
        urlLicenciaConducir = licenciaConducirSelected.value;
      }

      if (!soatSelected.value.isURL) {
        _filename = 'soat.jpg';
        final resSoat = await _repositorioProvider.sendFileBase64(
            fileName: _filename, base64: soatSelected.value);
        urlSoat = resSoat.url;
      } else {
        urlSoat = soatSelected.value;
      }

      if (!revisionTecnicaSelected.value.isURL) {
        _filename = 'revisiontecnica.jpg';
        final resRevisionTecnica = await _repositorioProvider.sendFileBase64(
            fileName: _filename, base64: revisionTecnicaSelected.value);
        urlRevisionTecnica = resRevisionTecnica.url;
      } else {
        urlRevisionTecnica = revisionTecnicaSelected.value;
      }

      if (!resoluciontaxiSelected.value.isURL) {
        _filename = 'resolucion.jpg';
        final resResoluciontaxi = await _repositorioProvider.sendFileBase64(
            fileName: _filename, base64: resoluciontaxiSelected.value);
        urlResoluciontaxi = resResoluciontaxi.url;
      } else {
        urlResoluciontaxi = resoluciontaxiSelected.value;
      }

      if (!tarjetacirculacionSelected.value.isURL) {
        _filename = 'tarjetacirculacion.jpg';
        final resTarjetacirculacionSelected =
            await _repositorioProvider.sendFileBase64(
                fileName: _filename, base64: tarjetacirculacionSelected.value);
        urlTarjetacirculacion = resTarjetacirculacionSelected.url;
      } else {
        urlTarjetacirculacion = tarjetacirculacionSelected.value;
      }

      if (!antecedentesPenalesSelected.value.isURL) {
        _filename = 'antecedentespenales.jpg';
        final resantecedentesPenalesSelected =
            await _repositorioProvider.sendFileBase64(
                fileName: _filename, base64: antecedentesPenalesSelected.value);
        urlantecedentesPenales = resantecedentesPenalesSelected.url;
      } else {
        urlantecedentesPenales = antecedentesPenalesSelected.value;
      }

      if (!antecedentesPolicialesSelected.value.isURL) {
        _filename = 'antecedentespoliciales.jpg';
        final resantecedentesPolicialesSelected =
            await _repositorioProvider.sendFileBase64(
                fileName: _filename,
                base64: antecedentesPolicialesSelected.value);
        urlantecedentesPoliciales = resantecedentesPolicialesSelected.url;
      } else {
        urlantecedentesPoliciales = antecedentesPolicialesSelected.value;
      }

      Random random = new Random();
      int randomNumber = random.nextInt(90000) + 10000;
      // Se deberia usar el put de savevehiculo

      // Helpers.logger.wtf(expiracionLicenciaCtlr.text);

      Helpers.logger.wtf(DateFormat("dd-MM-yyyy")
          .parse(expiracionLicenciaCtlr.text)
          .toString());

      await _vehiculoProvider.saveVehiculo(
        idVehiculo: accion == _AccionVehiculo.update ? vehiculo!.idVehiculo : 0,
        idConductor: _authX.backendUser!.idConductor,
        idTipoVehiculo: 1, // TODO: DESHARCODEAR.. AGREGAR EL SELECTOR
        idMarca: marcaSelected!.idMarca,
        placa: placaCtlr.text.toString().trim().toUpperCase(),
        asientos: 0,
        maletas: 0,
        foto: '',
        idModelo: marcaModeloSelected!.idModelo,
        idColor: colorSelected!.idColor,
        urlLicenciaConducir: urlLicenciaConducir,
        valLicenciaConducir: valLicenciaConducir,
        urlSoat: urlSoat,
        valSoat: valSoat,
        urlRevisionTecnica: urlRevisionTecnica,
        valRevisionTecnica: valRevisionTecnica,
        urlResolucionTaxi: urlResoluciontaxi,
        valResolucionTaxi: valResolucionTaxi,
        urlTarjetaCirculacion: urlTarjetacirculacion,
        valTarjetaCirculacion: valTarjetaCirculacion,

        valAntecedentesPenales: valAntecedentesPenales,
        valAntecedentesPoliciales: valAntecedentesPoliciales,

        urlAntecedentesPenales: urlantecedentesPenales,
        urlAntecedentesPoliciales: urlantecedentesPoliciales,

        expiracionLicencia: DateFormat("dd-MM-yyyy")
            .parse(expiracionLicenciaCtlr.text)
            .toString(),
        expiracionSoat:
            DateFormat("dd-MM-yyyy").parse(expiracionSoatCtlr.text).toString(),
        expiracionRevision: DateFormat("dd-MM-yyyy")
            .parse(expiracionRevisionCtlr.text)
            .toString(),
        expiracionResolucion: DateFormat("dd-MM-yyyy")
            .parse(expiracionResolucionCtlr.text)
            .toString(),
        expiracionTarjetacirculacion: DateFormat("dd-MM-yyyy")
            .parse(expiracionTarjetacirculacionCtlr.text)
            .toString(),
        expiracionPenales: DateFormat("dd-MM-yyyy")
            .parse(expiracionPenalesCtlr.text)
            .toString(),
        expiracionJudiciales: DateFormat("dd-MM-yyyy")
            .parse(expiracionJudicialesCtlr.text)
            .toString(),
        observacion: accion == _AccionVehiculo.update ? '' : observacion.value,
      );
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.toString());
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
        oSendButtonTap();
      } else {
        loading.value = false;
      }
    } else {
      AppSnackbar().success(message: 'Registro de vehiculo realizado.');
      await Helpers.sleep(2000);
      loading.value = false;
      // Get.offAllNamed(AppRoutes.MAPA);
      Get.offAllNamed(AppRoutes.REQUISITOS_REVISION);
    }
  }

  // Setteres
  void setMarcaSelected(Marca marca) {
    marcaCtlr.text = marca.marca;
    marcaSelected = marca;

    markModelsCtlr.text = '';
    marcaModeloSelected = null;

    _loadMarkModels(idMarca: marcaSelected!.idMarca);
  }

  void setModeloSelected(MarcaModelo modelo) {
    markModelsCtlr.text = modelo.modelo;
    marcaModeloSelected = modelo;
  }

  void setColorSelected(ColorAuto color) {
    colorCtlr.text = color.color;
    colorSelected = color;
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();

    bool canPop = Navigator.of(_context).canPop();
    if (canPop) {
      return true;
    } else {
      final exitAppConfirm = await Helpers.confirmCloseAppDialog();
      return exitAppConfirm;
    }
  }

  String? validatePlaca() {
    if (placaCtlr.text.trim().length == 7) {
      return null;
    }
    return 'Placa inválida';
  }

  void _launchModalWelcomeOrAdvice(BuildContext context, bool isWelcome) {
    showDialog(
        context: context,
        useSafeArea: true,
        barrierColor: Colors.black.withOpacity(.15),
        barrierDismissible: false,
        builder: (_) {
          return AppDialog(
            hideClose: false,
            onOkTap: () async => true,
            children: [
              SizedBox(height: 15.0),
              if (isWelcome)
                Row(
                  children: [
                    Flexible(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            child: AspectRatio(aspectRatio: 2 / 1),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Lottie.asset(
                              'assets/lottie/ok_icon.json',
                              repeat: true,
                              // width: Get.width * 0.20,
                              fit: BoxFit.fill,
                              delegates: LottieDelegates(
                                values: [
                                  for (var i = 1; i <= 42; i++)
                                    ValueDelegate.color(
                                        ['Shape Layer $i', '**'],
                                        value: (i == 1 || i == 42)
                                            ? akAccentColor
                                            : akPrimaryColor)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              if (isWelcome) SizedBox(height: 30.0),
              AkText(
                isWelcome ? 'Registro exitoso!' : 'Completa los documentos!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: akTitleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: akFontSize + 4.0,
                ),
              ),
              SizedBox(height: 12.0),
              AkText(
                isWelcome
                    ? 'Ya eres parte del grupo TaxiGuaa.\nAntes de empezar, debes completar la documentación necesaria para empezar a recibir pedidos de viaje.'
                    : 'Debes completar o corregir los documentos para recibir notifaciones de viaje.',
                textAlign: TextAlign.center,
              ),
            ],
          );
        });
  }
}

class RequisitosArguments {
  final bool enableBack;
  final bool shoWelcomeDialog;
  final bool showFixDocuments;
  RequisitosArguments({
    required this.enableBack,
    this.shoWelcomeDialog = false,
    this.showFixDocuments = false,
  });
}
