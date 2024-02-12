import 'package:app_driver_ns/data/models/cliente.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class ClienteProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/cliente';

  Future<ClienteCreateResponse> create(ClienteCreateParams data) async {
    final resp = await _dioClient.post('$_endpoint', data: data.toJson());
    return ClienteCreateResponse.fromJson(resp);
  }

  Future<ClientePorUidResponse> searchByUid(String uid) async {
    final resp = await _dioClient.get(
      '$_endpoint/uid',
      queryParameters: {'uid': uid},
    );
    return ClientePorUidResponse.fromJson(resp);
  }

  Future<ClienteListResponse> searchByPhoneNumber(String phone) async {
    final resp = await _dioClient.get(
      '$_endpoint/celular',
      queryParameters: {
        'phone': phone,
        'page': 1,
        'limit': 100,
      },
    );
    return ClienteListResponse.fromJson(resp);
  }

  Future<ClienteCreateResponse> updateFcmToken(
      int idCliente, String fcmToken) async {
    final resp = await _dioClient.put(
      '$_endpoint/fcm',
      queryParameters: {'id': idCliente, 'fcm': fcmToken},
    );
    return ClienteCreateResponse.fromJson(resp);
  }
}
