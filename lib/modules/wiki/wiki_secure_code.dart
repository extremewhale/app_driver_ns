import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WikiSecureCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: akPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: akWhiteColor,
            size: akFontSize + 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            padding: EdgeInsets.all(akContentPadding),
            child: Column(
              children: [
                AkText(
                  'Código de seguridad del viaje',
                  type: AkTextType.h5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                SvgPicture.asset(
                  'assets/icons/shield_ok_2.svg',
                  width: Get.size.width * 0.20,
                  color: Color(0xFF25BD87),
                ),
                SizedBox(height: 20.0),
                AkText(
                  'Este código funciona como segundo factor de seguridad para el pasajero y el conductor. Solicítalo amablemente al pasajero que lo visualizará en su aplicación.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: akTextColor.withOpacity(.65)),
                ),
              ],
            )),
      ),
    );
  }
}
