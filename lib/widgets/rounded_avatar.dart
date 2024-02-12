part of 'widgets.dart';

class RoundedAvatar extends StatelessWidget {
  final double size;

  const RoundedAvatar({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 4.0,
            offset: Offset(0.0, 4.0),
          )
        ],
        borderRadius: BorderRadius.circular(akCardBorderRadius * 0.75),
        image:
            DecorationImage(image: AssetImage('assets/img/default_avatar.png')),
      ),
    );
  }
}
