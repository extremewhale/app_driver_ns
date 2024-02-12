import 'package:app_driver_ns/modules/travel/rating/travel_rating_controller.dart';
import 'package:get/get.dart';

class TravelRatingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TravelRatingController());
  }
}
