import 'package:app_driver_ns/data/models/conductor.dart';
import 'package:app_driver_ns/data/providers/conductor_provider.dart';
import 'package:app_driver_ns/modules/auth/auth_controller.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/get.dart';

class BilleteraController extends GetxController {
  // Instances
  late BilleteraController _self;
  final _authX = Get.find<AuthController>();
  final _conductorProvider = ConductorProvider();

  final fetching = true.obs;

  List<Transaccione> lista = [];
  final tttotal = "".obs;

  @override
  void onInit() {
    super.onInit();
    _self = this;

    _init();
  }

  Future<void> _init() async {
    _fetchList();
  }

  final pendientepago = "".obs;
  final totalefectivo = "".obs;
  final saldoactual = "".obs;

  Future<void> _fetchList() async {
    String? errorMsg;
    lista = [];
    try {
      fetching.value = true;
      await Helpers.sleep(600);

      final resp = await _conductorProvider
          .getBilleteraConductor(_authX.backendUser!.idConductor);
      pendientepago.value = resp.pendientepago!;
      totalefectivo.value = resp.totalefectivo!;
      saldoactual.value = resp.saldoactual!;

      // lista = resp.transacciones!.toList();
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
