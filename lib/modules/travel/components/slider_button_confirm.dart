import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SliderButtonConfirm extends StatelessWidget {
  final void Function()? onSubmit;

  final String? prefixText;
  final String? mainText;
  final Color? btnColor;
  final Color? textColor;
  final Color? iconColor;

  SliderButtonConfirm(
      {Key? key,
      this.onSubmit,
      this.prefixText = '',
      this.mainText = '',
      this.btnColor,
      this.textColor,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _widgetColor = btnColor ?? akPrimaryColor;
    Color _textColor = textColor ?? akWhiteColor;
    Color _iconColor = iconColor ?? akWhiteColor;
    Widget _slider = SlideAction(
      // key: _conX.finishSlideKey,
      animationDuration: Duration(milliseconds: 0),
      submittedIcon: Icon(Icons.check_rounded, color: _iconColor),
      innerColor: _textColor.withOpacity(.15),
      outerColor: _widgetColor,
      sliderButtonIcon: Icon(Icons.double_arrow_rounded, color: _iconColor),
      borderRadius: 10.0,
      text: '',
      textStyle: TextStyle(color: _textColor),
      height: 68,
      sliderButtonIconPadding: 12,
      elevation: 0,
      sliderButtonYOffset: 4,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 70.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AkText(
              prefixText ?? '',
              type: AkTextType.caption,
              style: TextStyle(fontWeight: FontWeight.w400, color: _textColor),
            ),
            AkText(
              mainText ?? '',
              type: AkTextType.subtitle1,
              style: TextStyle(fontWeight: FontWeight.w600, color: _textColor),
            ),
          ],
        ),
      ),

      onSubmit: () {
        onSubmit?.call();
      },
    );

    return _slider;
  }
}
