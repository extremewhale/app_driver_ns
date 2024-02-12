import 'package:app_driver_ns/data/models/marca.dart';
import 'package:app_driver_ns/data/models/marca_modelo.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class MarcaProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/marca';

  Future<ListMarcaResponse> getAllMarcas({ required int page , required int limit }) async {
    final response = await _dioClient.get('$_endpoint', queryParameters: { 'page': page , 'limit': limit } );
    // print('Data: ' + response.toString());
    return ListMarcaResponse.fromJson(response);
  }

  Future<ListMarcaModelosResponse> getAllModels4Mark({ required int idMarca }) async {
    final response = await _dioClient.get('$_endpoint/modelos', queryParameters: { 'idMarca': idMarca } );
    // print('Data: ' + response.toString());
    return ListMarcaModelosResponse.fromJson(response);
  }

}