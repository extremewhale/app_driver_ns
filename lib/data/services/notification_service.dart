import 'package:app_driver_ns/data/models/notification_taxi_request.dart';
import 'package:app_driver_ns/data/services/shared_prefs_service.dart';
import 'package:app_driver_ns/modules/mapa/mapa_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
Future<void> _isolateBackgroundMessageHandler(RemoteMessage message) async {
  print('Background Notification received!');
  // Utilizamos SP solo para guardar las notificaciones y
  // porque tiene un metodo reload, punto más importante, que permite
  // sincronizar la data en los diferentes Isolates.
  if (message.data.isNotEmpty) {
    if (message.data['type'] == 'TAXI_REQUEST') {
      await SharedPrefsService.saveRequest(message.data);
      // await SharedPrefsService.cleanAllRequests();
      print('Background Notification saved!');
    }
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channelPushImportance;
late AndroidNotificationChannel channelDriverRequests;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class NotificationService {
  static final NotificationService _singleton = NotificationService._internal();
  factory NotificationService() {
    return _singleton;
  }
  NotificationService._internal();

  static String? token;

  static Future init() async {
    // Linea necesaria para obtener el Token.
    token = await FirebaseMessaging.instance.getToken();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_isolateBackgroundMessageHandler);

    if (!kIsWeb) {
      channelPushImportance = const AndroidNotificationChannel(
        NCH_ID_PUSHIMPORTANT,
        NCH_NAME_PUSHIMPORTANT,
        description: NCH_DESC_PUSHIMPORTANT,
        importance: Importance.high,
      );

      channelDriverRequests = const AndroidNotificationChannel(
        NCH_ID_DRIVERREQUEST,
        NCH_NAME_DRIVERREQUEST,
        description: NCH_DESC_DRIVERREQUEST,
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('request_travel'),
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channelPushImportance);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channelDriverRequests);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Handlers
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
  }

  // Handlers
  static Future _onMessageHandler(RemoteMessage message) async {
    print('_onMessageHandler');
    try {
      if (message.data.isNotEmpty) {
        if (message.data['type'] == 'TAXI_REQUEST') {
          final _mapX = Get.find<MapaController>();
          if (_mapX is MapaController) {
            final data = NotificationTaxiRequest.fromJson(message.data);
            _mapX.onNotificationRequestReceived([data]);
          }
        }
      }
    } catch (e) {
      print('Error en _onMessageHandler: ${e.toString()}');
    }
  }
}

const String NCH_ID_PUSHIMPORTANT = 'NCH_ID_PUSH_IMPORTANT';
const String NCH_NAME_PUSHIMPORTANT = 'Push Notifications High Importance';
const String NCH_DESC_PUSHIMPORTANT =
    'Push Notifications High Importance Channel';

const String NCH_ID_DRIVERREQUEST = 'NCH_ID_DRIVERREQUEST';
const String NCH_NAME_DRIVERREQUEST = 'Driver Request Notification';
const String NCH_DESC_DRIVERREQUEST = 'Driver Request Notification Channel';
