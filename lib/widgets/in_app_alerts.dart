part of 'widgets.dart';

class InAppAlerts {
  static Future<void> showNewService(
      {VoidCallback? onTap, VoidCallback? onCloseOrDismiss}) async {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      backgroundColor: akAccentColor,
      margin: EdgeInsets.all(0),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.GROUNDED,
      borderRadius: 0,
      titleText: AkText(
        'Solicitud de servicio',
        style: TextStyle(
          color: akTitleColor,
          fontWeight: FontWeight.w500,
          fontSize: akFontSize + 2.0,
        ),
      ),
      icon: Icon(Icons.taxi_alert),
      shouldIconPulse: false,
      dismissDirection: DismissDirection.horizontal,
      messageText: AkText(
        'Presiona para ver o desliza para cerrar',
        style: TextStyle(
          fontSize: akFontSize - 1.0,
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Color(0xFF8D8B8B).withOpacity(.20),
          blurRadius: 2,
          offset: Offset(0, 4),
        )
      ],
      duration: Duration(seconds: 10),
      onTap: (_) {
        onTap?.call();
      },
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          onCloseOrDismiss?.call();
        }
      },
    );
  }
}
