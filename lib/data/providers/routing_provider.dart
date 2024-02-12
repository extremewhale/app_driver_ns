import 'package:app_driver_ns/config/config.dart';
import 'package:app_driver_ns/data/models/driving_request_param.dart';
import 'package:app_driver_ns/data/models/google_driving_response.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:dio/dio.dart';

class RoutingProvider {
  // Asignar el tipo de retorno
  Future<GoogleDrivingResponse> calculateRoute(
      DrivingRequestParam origin, DrivingRequestParam destination) async {
    final _dio = Dio();
    final DioClient _dioClient =
        DioClient('https://maps.googleapis.com/maps/api', _dio);

    final response = await _dioClient.get('/directions/json', queryParameters: {
      'region': 'pe',
      'origin': '${origin.getParamToString()}',
      'destination': '${destination.getParamToString()}',
      'key': '${Config.API_GOOGLE_KEY}',
      'mode': 'driving',
      'language': 'es'
    });

    return GoogleDrivingResponse.fromJson(response);
  }
}
