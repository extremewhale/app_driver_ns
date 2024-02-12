part of 'widgets.dart';

class AttachButton extends StatelessWidget {
  final String title;
  final void Function()? onCameraTap;
  final void Function()? onGalleryTap;
  const AttachButton(
      {Key? key, this.title = '', this.onCameraTap, this.onGalleryTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 8.0,
        top: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AkText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: akTitleColor,
                    fontSize: akFontSize + 1.0,
                  ),
                ),
                AkText(
                  'Selecciona para adjuntar',
                  style: TextStyle(
                    fontSize: akFontSize - 1.0,
                    color: akTitleColor.withOpacity(.50),
                  ),
                )
              ],
            ),
          ),
          AkButton(
            contentPadding: EdgeInsets.all(12.0),
            onlyIcon: Icon(Icons.upload),
            onPressed: () async {
              // _conX.onbuttonSOATClick();
              final resp = await Get.dialog(
                  AlertDialog(
                    contentPadding: EdgeInsets.all(0.0),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    content: Container(
                      width: 1000.0,
                      constraints:
                          BoxConstraints(minHeight: 10.0, maxHeight: 300.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(akRadiusGeneral)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AkText('Selecciona alguna de estas opciones:'),
                          SizedBox(height: 15.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: AkButton(
                                onPressed: () {
                                  Get.back(result: 1);
                                },
                                text: 'Cámara',
                                fluid: true,
                                enableMargin: false,
                              )),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: AkButton(
                                onPressed: () {
                                  Get.back(result: 2);
                                },
                                text: 'Galeria',
                                fluid: true,
                                enableMargin: false,
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  barrierColor: Colors.black.withOpacity(0.35));

              if (resp == 1) {
                this.onCameraTap?.call();
              } else if (resp == 2) {
                this.onGalleryTap?.call();
              }
            },
            text: title,
            enableMargin: false,
          ),
        ],
      ),
    );
  }
}
