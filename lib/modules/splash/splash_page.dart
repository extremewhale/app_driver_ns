import 'package:animate_do/animate_do.dart';
import 'package:app_driver_ns/modules/splash/splash_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  final _conX = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    _conX.setContext(context);

    return Scaffold(
      backgroundColor: akPrimaryColor,
      // Cuando esto esta descomentado.. la animatión no perdura por el update()
      /* body: GetBuilder<SplashController>(
        builder: (_) => _conX.showPermissionReason
            ? FadeIn(child: _buildPermissionReasons())
            : _buildWelcome(),
      ), */
      body: Stack(
        children: [
          _buildWelcome(),
          Positioned.fill(
            child: GetBuilder<SplashController>(
              builder: (_) => _conX.showPermissionReason
                  ? FadeIn(child: _buildPermissionReasons())
                  : SizedBox(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => _conX.logoCacheLoaded.value
              ? FadeIn(
                  child: LogoApp(),
                )
              : SizedBox()),
          SizedBox(height: 40.0),
          /* SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideInLeft(
                duration: Duration(milliseconds: 300),
                child: Text('Taxi',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              SlideInRight(
                duration: Duration(milliseconds: 300),
                child: Text('.',
                    style: TextStyle(
                        color: akAccentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
            ],
          ),
          AkButton(
            onPressed: () {
              final authX = Get.find<AuthController>();
              authX.logout();
            },
            text: 'Logout',
          ), */
          // _buildLoading(),
        ],
      ),
    );
  }

  Widget _buildPermissionReasons() {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/location_map.svg',
                width: Get.size.width * 0.30,
                color: akTextColor,
              ),
              SizedBox(height: 20.0),
              AkCard(
                paddingSize: akContentPadding,
                margin: EdgeInsets.all(akContentPadding),
                boxShadowColor: Colors.black.withOpacity(.15),
                disableShadows: true,
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Icon(
                      Icons.location_off_outlined,
                      color: akTitleColor,
                      size: Get.width * 0.25,
                    ),
                    SizedBox(height: 15.0),
                    AkText(
                      'Ubicación no habilitada',
                      type: AkTextType.h7,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    AkText(
                      'Es necesario activar los permisos de ubicación para utilizar la aplicación correctamente.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    AkButton(
                      enableMargin: false,
                      onPressed: _conX.requestPermissionAgain,
                      text: 'Activar permisos',
                    )
                  ],
                ),
              ),
              SizedBox(height: 140.0),
            ],
          ),
        ),
      ),
    );
  }

  /* Widget _buildLoading() {
    return GetBuilder<SplashController>(
      builder: (_) {
        return _.loading
            ? FadeIn(
                duration: Duration(seconds: 1),
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  // child: SpinLoadingIcon(),
                ),
              )
            : SizedBox();
      },
    );
  } */
}
