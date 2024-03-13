import 'package:app_driver_ns/data/models/recargar.dart';

import 'package:app_driver_ns/data/models/yape_response.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/data/providers/recargar_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/billetera/billetera_controller.dart';
import 'package:app_driver_ns/modules/mapa/mapa_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RecargaController extends GetxController {
  late RecargaController _self;
  final montoController = TextEditingController();
  final MapaController _mapaController = Get.put(MapaController());
  final BilleteraController _billeteraController =
      Get.put(BilleteraController());
  final _conductorProvider = ConductorProvider();

  final telefonoController = TextEditingController();
  final codigoAprobacionController = TextEditingController();
  final _recargarProvider = RecargarProvider();
  final _authX = Get.find<AuthController>();

  Niubiz niubiz = Niubiz(); // Debe ser un objeto Niubiz con datos válidos

  RxInt tipoPago = 0.obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _self = this;
  }

  bool isValidMonto() {
    String montoString = montoController.text;

    if (montoString.isEmpty) {
      Get.snackbar('ups', 'Debes ingresar un monto');
      return false;
    }
    double montoTotal = double.parse(montoString);
    if (montoTotal <= 4) {
      Get.snackbar('ups', 'Debes ingresar un monto mayor a 5 soles');
      return false;
    }
    return true;
  }

  bool isValidData() {
    String telefono = telefonoController.text;
    String codigoAprobacion = codigoAprobacionController.text;

    if (telefono.isEmpty || codigoAprobacion.isEmpty) {
      Get.snackbar('ups', 'Debes ingresar los datos correspondientes');
      return false;
    }

    return true;
  }

  void goToPageMap() {
    Get.toNamed(AppRoutes.MAPA);
  }

  void payment() async {
    String montoString = montoController.text;
    String telefono = telefonoController.text.trim();
    String codigoAprobacion = codigoAprobacionController.text.trim();
    double montoTotal = double.parse(montoString);
    print('este es el id del conductor ${_authX.backendUser!.idConductor}');
    String commerce =
        "522591320"; // Valor de ejemplo, asegúrate de tener el valor correcto
    niubiz.channel = "pasarela";
    niubiz.captureType = "manual";
    niubiz.countable = "true";
    String _formatTwoDigitNumber(int number) {
      return number.toString().padLeft(2, '0');
    }

    DateTime now = DateTime.now();
    String formattedDateTime =
        "${now.year}-${_formatTwoDigitNumber(now.month)}-${_formatTwoDigitNumber(now.day)}T${_formatTwoDigitNumber(now.hour)}:${_formatTwoDigitNumber(now.minute)}:${_formatTwoDigitNumber(now.second)}";

    // Completa la información de recarga con los datos proporcionados
    niubiz.recarga = Recarga(
      idRecarga: 0,
      idtipoPagoRecarga: tipoPago.value,
      idConductor: _authX.backendUser!.idConductor,
      monto: montoTotal,
      codigoTransaccion: "",
      imgRecarga: "",
      fechaRegistro: formattedDateTime,
      valRecarga: true,
      enable: 1,
    );
    // Completa la información de order con los datos proporcionados
    niubiz.order = Order(
      purchaseNumber: "84335",
      amount: montoTotal,
      currency: "PEN",
    );
    // Completa la información de yape con los datos proporcionados
    niubiz.yape = Yape(
      phoneNumber: telefono,
      otp: codigoAprobacion,
    );
    loading.value = true;

    try {
      if (niubiz != null) {
        YapeResponse response = await _recargarProvider.payment(
          niubiz: niubiz,
          commerce: commerce,
        );

        // Aquí puedes imprimir o manejar la respuesta según tus necesidades
        print('Respuesta de la recarga: ${response.data}');
        if (response.statusCode == 200) {
          Get.snackbar('Recarga exitosa', '${response.data}');

          final resp = await _conductorProvider
              .getBilleteraConductor(_authX.backendUser!.idConductor);
          _mapaController.saldoactual.value = resp.saldoactual!;

          _billeteraController.saldoactual.value = resp.saldoactual!;

          montoController.text = '';

          telefonoController.text = '';
          codigoAprobacionController.text = '';
        } else {
          Get.snackbar('Ups', '${response.data}');
          montoController.text = '';
          telefonoController.text = '';
          codigoAprobacionController.text = '';
        }
        loading.value = false;
      } else {
        // Manejo de errores si niubiz es null
        Get.snackbar('Error',
            'Hubo un problema al realizar la recarga. hay un dato nulo');
        loading.value = false;
      }
    } catch (error) {
      // Manejo de errores, por ejemplo, si la recarga falla
      loading.value = false;
      Get.snackbar('Error', 'Hubo un problema al realizar la recarga');
      montoController.text = '';
      telefonoController.text = '';
      codigoAprobacionController.text = '';
    }
  }
}
