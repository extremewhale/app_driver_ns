import 'package:app_driver_ns/data/providers/travel_info_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:get/get.dart';

class TravelRatingArguments {
  final int? idServicioOld;

  const TravelRatingArguments({this.idServicioOld});
}

class TravelRatingController extends GetxController {
  int idServicioOld = 0;

  String clientName = '';

  static final initialRatingValue = 4.0;

  RxString ratingName = RxString('');
  double ratingValue = initialRatingValue;

  List<String> listRatingNames = [
    'Malo',
    'Regular',
    'Bueno',
    'Muy bueno',
    'Excelente!'
  ];

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is TravelRatingArguments) {
      final arguments = Get.arguments as TravelRatingArguments;
      idServicioOld = arguments.idServicioOld ?? idServicioOld;
    }

    _init();
  }

  var travelResp;

  void _init() async {
    changeRatingValue(initialRatingValue);
    // clientName = 'Alec González Coral';
  }

  void changeRatingValue(double value) {
    ratingValue = value;

    int ival = ratingValue.floor();
    ratingName.value = listRatingNames[ival - 1];
  }

  void onCloseTap() {
    _goToHome();
  }

  void saveRating() {
    print('Enviando reating');
    _goToHome();
  }

  void _goToHome() {
    Get.offAllNamed(AppRoutes.MAPA);
  }

  final _authX = Get.find<AuthController>();
  final _travelInfoProvider = TravelInfoProvider();

  Future<void> guardarCalificacion() async {
    try {
      final respRating = await _travelInfoProvider.putRatingDriver(
          this.idServicioOld, ratingValue);
      Get.offAllNamed(AppRoutes.MAPA);
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }
}
