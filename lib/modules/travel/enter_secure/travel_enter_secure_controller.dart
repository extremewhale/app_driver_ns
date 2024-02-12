import 'package:app_driver_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelEnterSecureArguments {
  final String secureCode;
  const TravelEnterSecureArguments(this.secureCode);
}

class TravelEnterSecureController extends GetxController {
  final secureCodeCtlr = TextEditingController();
  final secureFNode = FocusNode();

  String secureCode = '';

  final incorrectCode = false.obs;

  @override
  void onInit() {
    super.onInit();

    secureCodeCtlr.addListener(_onSecureCodeFocus);

    _init();
  }

  void _init() async {
    if (!(Get.arguments is TravelEnterSecureArguments)) {
      Helpers.showError('Error pasando los argumentos');
      return;
    }

    final arguments = Get.arguments as TravelEnterSecureArguments;
    secureCode = arguments.secureCode;

    await Helpers.sleep(400);
    secureFNode.requestFocus();
  }

  @override
  void onClose() {
    secureCodeCtlr.removeListener(_onSecureCodeFocus);
    secureFNode.dispose();
    super.onClose();
  }

  bool callOnce = false;
  void _onSecureCodeFocus() async {
    final txt = secureCodeCtlr.text;
    if (txt.length == 4) {
      if (txt == secureCode) {
        if (!callOnce) {
          // Para evitar que haga un doble back;
          callOnce = true;
          returnOkResult();
        }
      } else {
        incorrectCode.value = true;
      }
    } else {
      if (incorrectCode.value) {
        incorrectCode.value = false;
      }
    }
  }

  Future<void> returnOkResult() async {
    if (Helpers.keyboardIsVisible()) {
      Get.focusScope?.unfocus();
      await Helpers.sleep(300);
    }
    Get.back(result: true);
  }

  Future<void> onCloseTap() async {
    if (Helpers.keyboardIsVisible()) {
      Get.focusScope?.unfocus();
      await Helpers.sleep(300);
    }
    Get.back();
  }
}
