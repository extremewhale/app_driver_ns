import 'package:app_driver_ns/modules/travel/enter_secure/travel_enter_secure_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TravelEnterSecurePage extends StatelessWidget {
  final conX = Get.put(TravelEnterSecureController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  // color: akPrimaryColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8.0),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(300.0),
                        child: Material(
                          type: MaterialType.transparency,
                          child: IconButton(
                            onPressed: conX.onCloseTap,
                            icon: Icon(
                              Icons.clear,
                              color: akPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // color: akPrimaryColor,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(15.0),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: akContentPadding),
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          AkText(
                            'Ingresa el código de viaje del pasajero(a)',
                            type: AkTextType.h5,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.0),
                    SvgPicture.asset(
                      'assets/icons/lock_pattern_2.svg',
                      width: Get.size.width * 0.18,
                      color: akTextColor.withOpacity(.85),
                    ),
                    SizedBox(height: 30.0),
                    Obx(() => Column(
                          children: [
                            Container(
                              width: 140.0,
                              child: AkInput(
                                type: AkInputType.legend,
                                focusedBorderColor: conX.incorrectCode.value
                                    ? akErrorColor
                                    : akPrimaryColor,
                                enabledBorderColor: akPrimaryColor,
                                focusNode: conX.secureFNode,
                                controller: conX.secureCodeCtlr,
                                enableClean: false,
                                size: AkInputSize.massive,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: "####")
                                ],
                                keyboardType: TextInputType.number,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            conX.incorrectCode.value
                                ? AkText(
                                    'Código incorrecto',
                                    style: TextStyle(
                                      color: akErrorColor,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )),
                    GestureDetector(
                      onTap: () async {
                        Get.focusScope?.unfocus();
                        await Helpers.sleep(300);
                        await Get.toNamed(AppRoutes.WIKI_SECURE_CODE);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: AkText(
                          '¿Necesitas ayuda?',
                          style: TextStyle(
                            color: akSecondaryColor.withOpacity(.65),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
