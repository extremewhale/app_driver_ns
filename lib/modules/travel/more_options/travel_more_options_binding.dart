import 'package:app_driver_ns/modules/travel/more_options/travel_more_options_controller.dart';
import 'package:get/get.dart';

class TravelMoreOptionsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TravelMoreOptionsController());
  }
}
