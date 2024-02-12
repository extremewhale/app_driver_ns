import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';

class MyPositionMarker extends StatelessWidget {
  final double pSize;
  final Color pColor1 =
      akPrimaryColor.withOpacity(.65); // Helpers.darken(akPrimaryColor, .1);
  final Color pColor2 = Colors.red;
  final Color pTextColor = akPrimaryColor;
  final Color pIconColor = akWhiteColor.withOpacity(.35);

  MyPositionMarker({this.pSize = 70.0});

  @override
  Widget build(BuildContext context) {
    // final sizeTriangle = pSize * 0.15;

    return _pinDot(isOrigin: true, size: pSize * 0.6);
  }

  Widget _pinDot({bool isOrigin = true, double size = 30.0}) {
    Color destinyColor = pColor1;

    return _circleBlur(
      padding: size * 0.75,
      color: destinyColor.withOpacity(.075),
      child: _circleDot(size: size * 0.75, color: destinyColor),
    );
  }

  Widget _circleDot(
      {double size = 20.0,
      Color color = Colors.greenAccent,
      bool shadows = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500.0),
        color: color,
        border: Border.all(color: akWhiteColor, width: size * 0.05),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, size * 0.05),
            color: shadows ? Colors.black.withOpacity(.15) : Colors.transparent,
            blurRadius: size * 0.035,
            spreadRadius: size * 0.035,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.0), color: color),
        height: size,
        width: size,
        child: Icon(
          Icons.navigation_rounded,
          color: pIconColor,
          size: size * 0.7,
        ),
      ),
    );
  }

  Widget _circleBlur(
      {double padding = 20.0,
      Color color = Colors.greenAccent,
      Widget child = const SizedBox()}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200.0),
        color: color,
      ),
      child: child,
    );
  }
}

class DestinyMarker extends StatelessWidget {
  final String streetName;
  final bool origin;
  final double pSize;
  final Color pColor1 = akAccentColor; // Helpers.darken(akPrimaryColor, .1);
  final Color pColor2 = Colors.white;
  final Color pColor3 = akAccentColor;
  final Color pTextColor = akWhiteColor;
  final Color pIconColor = akWhiteColor;
  final Color borderDotColor = akWhiteColor;
  final bool hidePopup;

  DestinyMarker(
      {this.streetName = '',
      this.pSize = 40.0,
      this.origin = true,
      this.hidePopup = false});

  @override
  Widget build(BuildContext context) {
    // final sizeTriangle = pSize * 0.15;

    final popup = Stack(
      fit: StackFit.loose,
      children: [
        _buildShadow(),
        Column(
          children: [
            _buildBox(isOrigin: origin),
          ],
        ),
      ],
    );

    if (hidePopup) {
      return _pinDot(isOrigin: origin, size: pSize * 0.6);
    }

    return Stack(
      children: [
        Positioned(
          top: pSize * 0.5,
          left: 0.0,
          child: _pinDot(isOrigin: origin, size: pSize * 0.6),
        ),
        Container(
          child: popup,
          padding: EdgeInsets.only(
            left: pSize * 0.6,
            bottom: pSize * 1.5,
          ),
        ),
      ],
    );
  }

  Widget _pinDot({bool isOrigin = true, double size = 30.0}) {
    Color destinyColor = pColor3;

    return _circleBlur(
      padding: size * 0.25,
      color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.08),
      child: _circleBlur(
        padding: size * 0.35,
        color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.1),
        child: _circleBlur(
          padding: size * 0.1,
          color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.15),
          child: _circleDot(
              size: size * 0.5,
              color: isOrigin ? akPrimaryColor : destinyColor,
              shadows: isOrigin),
        ),
      ),
    );
  }

  Widget _circleDot(
      {double size = 20.0,
      Color color = Colors.greenAccent,
      bool shadows = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500.0),
        color: color,
        border: Border.all(color: borderDotColor, width: size * 0.25),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, size * 0.15),
            color: shadows ? color.withOpacity(.15) : Colors.transparent,
            blurRadius: size * 0.35,
            spreadRadius: size * 0.15,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.0), color: color),
        height: size,
        width: size,
      ),
    );
  }

  Widget _circleBlur(
      {double padding = 20.0,
      Color color = Colors.greenAccent,
      Widget child = const SizedBox()}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200.0),
        color: color,
      ),
      child: child,
    );
  }

  Widget _buildBox({bool isOrigin = true}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(pSize * 0.1),
      child: Container(
        decoration: BoxDecoration(
          color: isOrigin ? pColor1 : pColor1,
        ),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: pSize * 0.2),
                child: Icon(
                  isOrigin ? Icons.my_location : Icons.location_on_rounded,
                  size: pSize * 0.35,
                  color: isOrigin ? pIconColor : pIconColor,
                ),
              ),
              Container(
                // color: pColor2,
                height: pSize * 0.85,
                width: pSize * 1.7,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: pSize * 0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: AkText(
                        streetName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: pSize * 0.35,
                          color: pTextColor,
                          // fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: pSize * 0.25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShadow() {
    final factor = 0.05;

    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.only(
          top: pSize * factor * 2,
          left: pSize * factor,
          right: pSize * factor * 0.5,
          bottom: pSize * factor * 0.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: pSize * 0.05,
              spreadRadius: pSize * 0.075,
            ),
          ],
        ),
      ),
    );
  }
}

class PopupMarker extends StatelessWidget {
  final String streetName;
  final bool mini;
  final bool origin;
  final double pSize;
  final Color pColor1 = akPrimaryColor; // Helpers.darken(akPrimaryColor, .1);
  final Color pColor2 = Colors.white;
  final Color pTextColor = akPrimaryColor;
  final Color pIconColor = Colors.white;
  final bool onlyDot;

  PopupMarker({
    this.streetName = '',
    this.mini = false,
    this.pSize = 40.0,
    this.origin = true,
    this.onlyDot = false,
  });

  @override
  Widget build(BuildContext context) {
    // final sizeTriangle = pSize * 0.15;

    final popup = Stack(
      fit: StackFit.loose,
      children: [
        _buildShadow(),
        Column(
          children: [
            _buildBox(isOrigin: origin),
            /* Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(math.pi),
              child: Container(
                width: sizeTriangle,
                child: AspectRatio(
                  aspectRatio: 20 / 8,
                  child: CustomPaint(
                    painter: _DrawTriangleShape(colorTriangle: pColor2),
                  ),
                ),
              ),
            ), */
          ],
        ),
      ],
    );

    return Stack(
      children: [
        Positioned(
          top: onlyDot ? 0.0 : pSize * 0.5,
          left: 0.0,
          child: _pinDot(isOrigin: origin, size: pSize * 0.6),
        ),
        onlyDot
            ? Container(
                child: SizedBox(width: pSize * 1.25, height: pSize * 1.25),
                /* decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                ), */
              )
            : Container(
                child: popup,
                padding: EdgeInsets.only(
                  left: pSize * 0.6,
                  bottom: pSize * 0.8,
                ),
                /* decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                ), */
              ),
      ],
    );
  }

  Widget _pinDot({bool isOrigin = true, double size = 30.0}) {
    Color destinyColor = akSecondaryColor;

    return _circleBlur(
      padding: size * 0.25,
      color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.08),
      child: _circleBlur(
        padding: size * 0.35,
        color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.1),
        child: _circleBlur(
          padding: size * 0.1,
          color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.15),
          child: _circleDot(
              size: size * 0.5,
              color: isOrigin ? akPrimaryColor : destinyColor,
              shadows: isOrigin),
        ),
      ),
    );
  }

  Widget _circleDot(
      {double size = 20.0,
      Color color = Colors.greenAccent,
      bool shadows = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500.0),
        color: color,
        border: Border.all(color: akWhiteColor, width: size * 0.25),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, size * 0.15),
            color: shadows ? color.withOpacity(.15) : Colors.transparent,
            blurRadius: size * 0.35,
            spreadRadius: size * 0.15,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.0), color: color),
        height: size,
        width: size,
      ),
    );
  }

  Widget _circleBlur(
      {double padding = 20.0,
      Color color = Colors.greenAccent,
      Widget child = const SizedBox()}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200.0),
        color: color,
      ),
      child: child,
    );
  }

  Widget _buildBox({bool isOrigin = true}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(pSize * 0.1),
      child: Container(
        decoration: BoxDecoration(
          color: isOrigin ? pColor1 : pColor1,
        ),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: pSize * 0.2),
                child: Icon(
                  isOrigin ? Icons.my_location : Icons.location_on_rounded,
                  size: pSize * 0.35,
                  color: isOrigin ? pIconColor : pIconColor,
                ),
              ),
              Container(
                color: pColor2,
                height: pSize * 0.85,
                width: mini ? pSize * 1.85 : pSize * 3,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: pSize * 0.18, vertical: pSize * 0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: AkText(
                        streetName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: mini ? pSize * 0.35 : pSize * 0.25,
                          color: pTextColor,
                          // fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    mini
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(
                              left: pSize * 0.1,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: pSize * 0.3,
                              color: pTextColor,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShadow() {
    final factor = 0.05;

    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.only(
          top: pSize * factor * 2,
          left: pSize * factor,
          right: pSize * factor * 0.5,
          bottom: pSize * factor * 0.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: pSize * 0.05,
              spreadRadius: pSize * 0.075,
            ),
          ],
        ),
      ),
    );
  }
}
