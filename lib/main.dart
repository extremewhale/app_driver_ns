import 'package:app_driver_ns/data/services/notification_service.dart';
import 'package:app_driver_ns/instance_binding.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('app_data');
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();

  // Ensure that external dependencies are initialized before runApp
  await NotificationService.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that customizeAkStyle is called after necessary dependencies are initialized
    customizeAkStyle();

    return GetMaterialApp(
      initialBinding: InstanceBinding(),
      title: 'TaxiGuaa Driver',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''),
      ],
      theme: dfAppThemeLight,
      darkTheme: dfAppThemeDark,
      debugShowCheckedModeBanner: true,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        print('FLOG: widget is resumed');
        break;
      case AppLifecycleState.inactive:
        print('FLOG: widget is inactive');
        break;
      case AppLifecycleState.paused:
        print('FLOG: widget is paused');
        break;
      case AppLifecycleState.detached:
        print('FLOG: widget is detached');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }
}
