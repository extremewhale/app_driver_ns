import 'dart:async';
import 'dart:convert';

import 'package:app_driver_ns/config/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get message => _streamController.stream;

  String token = '';

  void initPushNotifications() async {
    /* String? d = await FirebaseMessaging.instance.getToken();
    if (d != null) {
      print('FLOG: El token de usuario: ${d}');
    } */

    // ON LAUNCH
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        print('initial Message');
        Map<String, dynamic> data = message.data;
        _streamController.sink.add(data);
      }
    });

    // ON MESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('OnMessage $message');
      Map<String, dynamic> data = message.data;
      _streamController.sink.add(data);
    });

    // ON RESUME
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('OnResume $message');
      Map<String, dynamic> data = message.data;
      _streamController.sink.add(data);
    });
  }

  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String title, String body) async {
    Uri uri = Uri.https('fcm.googleapis.com', 'fcm/send');
    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Config.FCM_SERVER_KEY}'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }));
  }

  void dispose() {
    _streamController.close();
  }
}
