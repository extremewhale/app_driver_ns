import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:app_driver_ns/modules/intro/intro_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatelessWidget {
  final _conX = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canPop = Navigator.of(context).canPop();
        if (canPop) {
          return true;
        } else {
          final exitAppConfirm = await Helpers.confirmCloseAppDialog();
          return exitAppConfirm;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: akScaffoldBackgroundColor,
        body: Container(
          child: Stack(
            children: [
              _buildFullStock(),
              _buildNavigationWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullStock() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/driver_stock.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildNavigationWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FadeInUp(
        duration: Duration(milliseconds: 700),
        child: Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(math.pi),
                child: Container(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 8 / 1,
                      child: CustomPaint(
                        painter: CurvePainter2(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  _buildSlogan(),
                  _buildBtnEmpezar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlogan() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: akContentPadding * 0.5,
            left: akContentPadding,
            right: akContentPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AkText(
                'Vocación de servicio',
                style: TextStyle(
                  color: akTitleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: akFontSize + 10.0,
                ),
              ),
              SizedBox(height: 10.0),
              AkText('Únete a nuestra comunidad de conductores.',
                  style: TextStyle(
                      fontSize: akFontSize + 2.0,
                      color: akTextColor.withOpacity(.75),
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 15),
            ],
          ),
        ),
        Positioned(
          top: -2.0,
          left: 0,
          right: 0,
          child: Container(
            height: 5.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBtnEmpezar() {
    return Padding(
      padding: EdgeInsets.only(
        top: 5.0,
        bottom: akContentPadding,
        left: akContentPadding,
        right: akContentPadding,
      ),
      child: AkButton(
        onPressed: _conX.goToLoginPhonePage,
        enableMargin: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 15.0,
            ),
            AkText(
              'Empezar',
              style: TextStyle(color: akWhiteColor, fontSize: akFontSize + 2),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: akFontSize + 5,
              color: akWhiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
