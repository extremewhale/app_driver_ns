import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  late BuildContext context;

  final _authX = Get.find<AuthController>();

  bool loading = true;
  bool showPermissionReason = false;
  bool fromSettingsPage = false;

  final logoCacheLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _init();
    });
  }

  void setContext(BuildContext c) {
    context = c;
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && fromSettingsPage) {
      fromSettingsPage = false;
      if (await Permission.location.isGranted) {
        onPermissionOk();
      }
    }
  }

  Future<void> _init() async {
    print('SplashController._init');
    await _preloadImages();

    checkAppPermissions();
  }

  void onPermissionOk() async {
    showPermissionReason = false;
    update();
    print('Permissions granted!');

    _authX.initCheckSession();
  }

  Future checkAppPermissions() async {
    bool permissionLocation = await Permission.location.isGranted;

    PermissionStatus? plocationStatus;
    if (!permissionLocation) {
      plocationStatus = await Permission.location.request();
    }

    bool permissionPhone = await Permission.phone.isGranted;
    if (!permissionPhone) {
      await Permission.phone.request();
    }

    if (permissionLocation) {
      onPermissionOk();
    } else {
      handlePermissionLocationResponse(plocationStatus!);
    }
  }

  Future handlePermissionLocationResponse(PermissionStatus status) async {
    print(status);
    switch (status) {
      case PermissionStatus.granted:
        onPermissionOk();
        break;
      case PermissionStatus.limited:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        showPermissionReason = true;
        update();
        break;
      case PermissionStatus.provisional:
      // TODO: Handle this case.
    }
  }

  void requestPermissionAgain() async {
    PermissionStatus _ps = await Permission.location.request();
    switch (_ps) {
      case PermissionStatus.granted:
        onPermissionOk();
        break;
      case PermissionStatus.denied:
        break;
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        if (await openAppSettings()) {
          fromSettingsPage = true;
        }
        break;
      case PermissionStatus.provisional:
      // TODO: Handle this case.
    }
  }

  Future<void> _preloadImages() async {
    /* PictureProvider.cache.clear();
    print('holaaaa');
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/icons/car_driving.svg'),
        context); */

    try {
      await precacheImage(AssetImage('assets/img/logo_oficial.png'), context);
      logoCacheLoaded.value = true;

      await precacheImage(AssetImage('assets/img/car_driving.png'), context);
    } catch (e) {
      print('Error en _preloadImages');
    }

    // The first time, the next line is executed correctly.
    // But, ehen I press Restart app, the following line is not executed. The app
    // Helpers.logger.wtf('Go to page that contains svg key');
  }
}
