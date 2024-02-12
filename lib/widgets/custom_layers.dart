part of 'widgets.dart';

class DimmerOffline extends StatelessWidget {
  const DimmerOffline();

  @override
  Widget build(BuildContext context) {
    final size = Get.size;
    final color = akPrimaryColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size.height,
          height: size.height,
          alignment: Alignment.center,
          child: SizedBox(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.30),
                color.withOpacity(0.30),
                color.withOpacity(0.6),
                color.withOpacity(0.7),
                color.withOpacity(0.7),
                color.withOpacity(0.9),
                color.withOpacity(0.9),
                color.withOpacity(0.9),
                color.withOpacity(0.9),
              ],
              focal: Alignment.center,
              radius: 2.0,
            ),
          ),
        )
      ],
    );
  }
}
