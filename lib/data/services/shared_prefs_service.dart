import 'dart:convert';

import 'package:app_driver_ns/data/models/notification_taxi_request.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static final SharedPrefsService _singleton = SharedPrefsService._internal();
  factory SharedPrefsService() {
    return _singleton;
  }
  SharedPrefsService._internal();

  static const _LAST_REQUESTS = 'lastRequests';

  static Future<List<NotificationTaxiRequest>> getRequests() async {
    List<NotificationTaxiRequest> savedRequest = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final encodedNoti = prefs.get(_LAST_REQUESTS);
      if (encodedNoti is String && encodedNoti.isNotEmpty) {
        List requests = jsonDecode(encodedNoti);
        savedRequest =
            (requests.map((e) => NotificationTaxiRequest.fromJson(e))).toList();
      }
    } catch (e) {
      Helpers.logger.e('Error en getRequests');
    }
    return savedRequest;
  }

  static Future<bool> saveRequest(Map<String, dynamic> data) async {
    // Esta funcíon recupera las notificaciones grabadas en el teléfono
    // y añade la nueva notificación al array.
    // Solo mantiene las últimas 3 notificaciones
    try {
      List<NotificationTaxiRequest> savedRequests = await getRequests();
      final newNotification = NotificationTaxiRequest.fromJson(data);
      List requestsJson = (savedRequests.map((e) => e.toJson())).toList();
      // Lógica que mantiene las últimas notificaciones según MaxStored.
      // MaxStored debe ser mayor a 1
      final maxStored = 3;
      if (requestsJson.length >= maxStored) {
        requestsJson.removeRange(0, (requestsJson.length + 1) - maxStored);
      }
      requestsJson.add(newNotification.toJson());
      final encodeNotications = jsonEncode(requestsJson);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_LAST_REQUESTS, encodeNotications);
      return true;
    } catch (e) {
      Helpers.logger.e('Error en saveRequest');
      return false;
    }
  }

  static Future<void> cleanAllRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_LAST_REQUESTS);
    } catch (e) {
      Helpers.logger.e('Error en cleanAllRequests');
    }
  }
}
