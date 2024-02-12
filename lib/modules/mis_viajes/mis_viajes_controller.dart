import 'package:app_driver_ns/data/models/servicio.dart';
import 'package:app_driver_ns/data/providers/servicio_provider.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/get.dart';

class MisViajesController extends GetxController {
  // Instances
  late MisViajesController _self;
  final _servicioProvider = ServicioProvider();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  final fetching = true.obs;

  List<ServicioModelItem> lista = [];

  @override
  void onInit() {
    super.onInit();
    _self = this;

    _init();
  }

  void filterListByDate() {
    if (selectedStartDate == null || selectedEndDate == null) return;

    lista = lista.where((servicio) {
      return servicio.fechaSalida
              .isAfter(selectedStartDate!.subtract(const Duration(days: 1))) &&
          servicio.fechaSalida
              .isBefore(selectedEndDate!.add(const Duration(days: 1)));
    }).toList();
    update(); // Para actualizar la vista
  }

  Future<void> _init() async {
    _fetchList();
  }

  Future<void> _fetchList() async {
    String? errorMsg;
    lista = [];
    try {
      fetching.value = true;
      await Helpers.sleep(600);
      final resp = await _servicioProvider.getByClient();
      lista = resp.content.reversed.toList();
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _fetchList();
      } else {
        fetching.value = false;
      }
    } else {
      fetching.value = false;
    }
  }
}
