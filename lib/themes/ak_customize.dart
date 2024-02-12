part of 'ak_ui.dart';

// NOTA:
// Para visualizar todos los cambios debe hacer un Hot Restart
// de lo contrario, algunos colores, medidas y estilos
// NO se actualizarán correctamente.

double akRadiusDrawerContainer = akRadiusGeneral; //+ 15.0
double akRadiusSnackbar = akRadiusGeneral;
double akMapPaddingBase = 12.0;

void customizeAkStyle() {
  akPrimaryColor = Color(0xFF282828);
  akSecondaryColor = Color(0xFFFF9900);
  akAccentColor = Color(0xFFF7CC46);

  akDefaultFontFamily = 'Rubik';

  akFontSize = 15.0;
  // if (Get.width != null && Get.width >= 360.0) {
  //   akContentPadding = 18.0; // 20.0;
  // } else {
  //   akContentPadding = 15.0; // 12.0;
  // }

  akTitleColor = akPrimaryColor;
  akTextColor = akTitleColor.withOpacity(.60);

  akContentPadding = 20.0;
  akAppbarBackgroundColor = akAccentColor;
  akAppbarTextColor = akTextColor;
  akAppbarElevation = 0.0;

  // Changing default app flutter theme
  dfAppThemeLight = dfAppThemeLight.copyWith(
    appBarTheme: dfAppBarLight.copyWith(
      titleTextStyle: dfAppBarTitleStyle.copyWith(color: akPrimaryColor),
      iconTheme: dfAppBarIconTheme.copyWith(color: akPrimaryColor),
    ),
  );
}
