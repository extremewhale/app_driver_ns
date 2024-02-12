part of 'widgets.dart';

class AppDialog extends StatelessWidget {
  final List<Widget> children;
  final bool hideClose;
  final WillPopCallback? onOkTap;
  final WillPopCallback? onCancelTap;

  const AppDialog(
      {Key? key,
      this.children = const [],
      this.hideClose = false,
      this.onOkTap,
      this.onCancelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(akContentPadding * 0.85),
      elevation: 0.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50.0,
          maxHeight: availableHeight,
          minWidth: 100.0,
          maxWidth: Get.width,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 12.0,
                    offset: Offset(0.0, 6.0),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(akContentPadding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...children,
                            ],
                          ),
                        ),
                        if (onOkTap != null)
                          _DialogButton(
                            text: 'ENTENDIDO',
                            bgColor: akPrimaryColor,
                            textColor: akWhiteColor,
                            onTap: () async {
                              if (await onOkTap?.call() ?? false) {
                                Get.back();
                              }
                            },
                          ),
                        if (onOkTap != null && onCancelTap != null)
                          SizedBox(height: 0.5),
                        if (onCancelTap != null)
                          _DialogButton(
                            text: 'CANCELAR',
                            bgColor: Helpers.lighten(Colors.grey, 0.3),
                            onTap: () async {
                              if (await onCancelTap?.call() ?? false) {
                                Get.back();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!hideClose)
              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        'assets/icons/close.svg',
                        width: akFontSize - 1.0,
                        color: akTextColor.withOpacity(.30),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const _DialogButton({
    Key? key,
    this.text = '',
    this.bgColor,
    this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnColor = bgColor ?? akPrimaryColor;

    return Container(
      color: bgColor ?? akPrimaryColor,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: Helpers.darken(btnColor, 0.14),
          highlightColor: Helpers.darken(btnColor, 0.07),
          onTap: () {
            onTap?.call();
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(akContentPadding * 0.75),
            child: AkText(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
