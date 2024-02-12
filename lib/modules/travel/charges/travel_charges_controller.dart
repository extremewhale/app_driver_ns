import 'package:app_driver_ns/data/models/extra_charge.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TravelChargesController extends GetxController {
  final amountCtrl = TextEditingController();
  final amountIptFocus = FocusNode();
  final list = <ExtraCharge>[];
  int? idxSelected;
  final showInputAmount = false.obs;

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  void _init() async {
    list.addAll([
      ExtraCharge(
        finalAmount: '10.0',
        fullText: 'Aeropuerto: Viaje Termina en aeropuerto (S/. 10)',
        shortText: 'Aeropuerto',
      ),
      ExtraCharge(
        finalAmount: '10.0',
        fullText: 'Aeropuerto (S/. 10) + Peaje(s)',
        shortText: 'Aeropuerto + Peaje(s)',
        mustAddAmount: true,
      ),
      ExtraCharge(
        finalAmount: '0.0',
        fullText: 'Peaje(s)',
        shortText: 'Peaje(s)',
        mustAddAmount: true,
      ),
    ]);
  }

  void onItemTap(int index) {
    amountCtrl.text = '0.00';
    idxSelected = index;
    update(['gbListCharges']);

    if (idxSelected != null && list[idxSelected!].mustAddAmount) {
      showInputAmount.value = true;
      amountIptFocus.requestFocus();
    } else {
      showInputAmount.value = false;
    }
  }

  void onAddTap() {
    if (idxSelected == null) {
      AppSnackbar().warning(message: 'Debes seleccionar una opción.');
    } else {
      double finalAmount = 0.0;
      double itemAmount = double.parse(list[idxSelected!].finalAmount);
      double additionalAmount = 0.0;

      if (showInputAmount.value) {
        additionalAmount = double.parse(amountCtrl.text);

        if (additionalAmount == 0.0) {
          AppSnackbar().warning(message: 'El monto debe ser diferente de 0.00');
          return;
        }
      }

      finalAmount = itemAmount + additionalAmount;
      final finalAmountStr = finalAmount.toStringAsFixed(2);

      final fExtraCharge = ExtraCharge(
        fullText: list[idxSelected!].fullText,
        shortText: list[idxSelected!].shortText,
        finalAmount: finalAmountStr,
      );
      Get.back(result: fExtraCharge);
    }
  }

  void onBackTap() {
    Get.back();
  }
}
