import 'package:app_driver_ns/config/config.dart';
import 'package:app_driver_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/keyboard/keyboard_controller.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class InstanceBinding extends Bindings {
  @override
  void dependencies() {
    final Dio _dio = Dio();

    //Get.put(DioClient(Config.URL_API_BACKEND, _dio));
    Get.put(DioClient(
      Config.URL_API_BACKEND,
      _dio,
      interceptors: [],
    ));

    final Dio _dioMailJet = Dio();
    Get.put(DioMailJet(_dioMailJet));
    Get.put(AuthController());

    Get.put(AppPrefsController());

    Get.put(KeyboardController());
    Get.put(DioClient(
      Config.URL_API_BACKEND,
      _dio,
      interceptors: [
        AppInterceptors(),
      ],
    ));
  }
}

class AppInterceptors extends InterceptorsWrapper {
  final _authX = Get.find<AuthController>();

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_authX.getUser != null) {
      options.headers["Authorization"] = Config.TOKEN;
    }

    return super.onRequest(options, handler);
  }

  @override
  onResponse(dynamic response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != '/securitysystem/login') {
      AppSnackbar()
          .error(message: 'Sesión caducada!\nInicie sesión nuevamente');
      _authX.logout();
    } else {
      super.onError(err, handler);
    }
  }
}

class DioMailJet extends DioClient {
  DioMailJet(Dio? dio) : super('https://api.mailjet.com/v4', dio);
}
