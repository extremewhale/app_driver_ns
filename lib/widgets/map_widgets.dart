part of 'widgets.dart';

class MapPlaceholder extends StatelessWidget {
  final bool ignorePoint;
  final bool hideLocalizando;
  final String text;

  const MapPlaceholder(
      {this.ignorePoint = false,
      this.hideLocalizando = false,
      this.text = 'Localizando...'});

  @override
  Widget build(BuildContext context) {
    Widget placeHolder = Container(
      decoration: BoxDecoration(
        color: Color(0xFFDCE4E4),
        image: DecorationImage(
          image: AssetImage("assets/img/mapholder.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: this.hideLocalizando
          ? Center(child: SizedBox())
          : Center(
              child: FadeIn(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AkButton(
                      enableMargin: false,
                      text: this.text,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          width: 15.0,
                          height: 15.0,
                          child: SpinLoadingIcon(
                            strokeWidth: 1.5,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(height: 5.0),
                    _DotCircle(
                      padding: 12.0,
                      opacity: .15,
                      child: _DotCircle(
                        padding: 7.0,
                        opacity: .35,
                        child: _DotCircle(
                          opacity: 1,
                          child: SizedBox(
                            height: 2.0,
                            width: 2.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );

    return ignorePoint ? IgnorePointer(child: placeHolder) : placeHolder;
  }
}

class _DotCircle extends StatelessWidget {
  final Widget child;

  final double padding;

  final double opacity;

  const _DotCircle(
      {this.child = const SizedBox(), this.padding = 3.0, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: akPrimaryColor.withOpacity(opacity),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class StartingPlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dfStyle = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: akFontSize + 8.0);

    return Container(
      color: akPrimaryColor.withOpacity(1),
      width: Get.size.width,
      height: Get.size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AkText('COMENZANDO UN', style: _dfStyle),
          SizedBox(height: 10.0),
          SvgPicture.asset(
            'assets/icons/car_stars.svg',
            width: Get.size.width * 0.35,
            color: Colors.white,
          ),
          SizedBox(height: 20.0),
          AkText('NUEVO SERVICIO', style: _dfStyle),
        ],
      ),
    );
  }
}

class ButtonBackMap extends StatelessWidget {
  final void Function() onPressed;
  final double? contentPadding;

  const ButtonBackMap({required this.onPressed, this.contentPadding});

  @override
  Widget build(BuildContext context) {
    final _cp = this.contentPadding != null ? this.contentPadding : 5.5;

    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: akContentPadding,
            left: akContentPadding * 0.5,
          ),
          child: AkButton(
            borderRadius: 6.0,
            enableMargin: false,
            contentPadding: EdgeInsets.all(_cp!),
            elevation: 1.0,
            size: AkButtonSize.big,
            variant: AkButtonVariant.primary,
            child: Icon(Icons.arrow_back_rounded, color: akWhiteColor),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class ButtonCenterMap extends StatelessWidget {
  final void Function() onPressed;
  final double? contentPadding;

  const ButtonCenterMap({required this.onPressed, this.contentPadding});

  @override
  Widget build(BuildContext context) {
    final _cp = this.contentPadding != null ? this.contentPadding : 12.5;

    return AkButton(
      borderRadius: 50.0,
      enableMargin: false,
      contentPadding: EdgeInsets.all(_cp!),
      elevation: 1.0,
      size: AkButtonSize.big,
      onlyIcon: Icon(Icons.my_location),
      textColor: akPrimaryColor,
      variant: AkButtonVariant.white,
      onPressed: onPressed,
    );
  }
}

class CommonButtonMap extends StatelessWidget {
  final void Function()? onTap;
  final IconData? icon;
  final bool isDark;
  final Widget? child;
  final EdgeInsetsGeometry? contentPadding;

  CommonButtonMap(
      {required this.onTap,
      this.icon,
      this.isDark = false,
      this.child,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = SizedBox();
    if (child != null) {
      buttonChild = child!;
    } else {
      if (icon != null) {
        buttonChild = Icon(
          icon,
          color: isDark ? akWhiteColor : akTextColor,
          size: akFontSize * 1.35,
        );
      }
    }

    final _cp = 9.0;
    EdgeInsetsGeometry buttonPadding = EdgeInsets.all(_cp);
    if (contentPadding != null) {
      buttonPadding = contentPadding!;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          BoxShadow(
            color: akPrimaryColor.withOpacity(.1),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(1.0, 2.0),
          )
        ],
      ),
      child: AkButton(
        borderRadius: 6.0,
        enableMargin: false,
        contentPadding: buttonPadding,
        elevation: 1.0,
        size: AkButtonSize.big,
        variant: isDark ? AkButtonVariant.primary : AkButtonVariant.white,
        child: buttonChild,
        onPressed: () {
          onTap?.call();
        },
      ),
    );
  }
}

class NavigateButtonMap extends StatelessWidget {
  final void Function()? onTap;

  final bool isDark;

  NavigateButtonMap({required this.onTap, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final _cp = 9.0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          BoxShadow(
            color: akPrimaryColor.withOpacity(.1),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(1.0, 2.0),
          )
        ],
      ),
      child: AkButton(
        backgroundColor: Color(0xFF3A57E5),
        borderRadius: 6.0,
        enableMargin: false,
        contentPadding: EdgeInsets.all(_cp),
        elevation: 1.0,
        size: AkButtonSize.big,
        variant: isDark ? AkButtonVariant.primary : AkButtonVariant.white,
        child: Row(
          children: [
            Icon(
              Icons.navigation,
              color: akWhiteColor,
              size: akFontSize * 1.35,
            ),
            SizedBox(width: 5.0),
            AkText(
              'Navegar'.toUpperCase(),
              style: TextStyle(
                color: akWhiteColor,
                fontSize: akFontSize - 3.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 3.0),
          ],
        ),
        onPressed: () {
          onTap?.call();
        },
      ),
    );
  }
}
