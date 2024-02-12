part of 'widgets.dart';

/* class LogoApp extends StatelessWidget {
  final double width;
  final bool light;

  const LogoApp({this.width = 40, this.light = false});

  @override
  Widget build(BuildContext context) {
    Widget logo = SvgPicture.asset(
        this.light
            ? 'assets/icons/xing_white.svg'
            : 'assets/icons/xing_normal.svg',
        width: this.width);

    return SizedBox();
  }
} */

class LogoApp extends StatelessWidget {
  const LogoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: (Get.width * 0.35 + 300.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Bounce(
            key: ValueKey('vkBounceLogo'),
            from: 10,
            infinite: true,
            child: Image.asset(
              'assets/img/logo_oficial.png',
              width: Get.width * 0.25,
            ),
          ),
          SizedBox(height: 15.0),
          const AkText(
            'Taxi Guaa',
            type: AkTextType.h5,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          SizedBox(height: 10.0),
          AkText(
            'Aplicación del conductor',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.60),
              fontSize: akFontSize + 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
