// 4E:80:0D:18:01:37:88:B6:4F:D5:82:2C:DB:64:AE:5D:94:5B:2A:DE

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();

  static Stream<String> get messagesstream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print(message.data);
    // print('onMessage Handler ${message.messageId}');
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenAp(RemoteMessage message) async {
    // print('onMessageOpenAp Handler ${message.messageId}');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    //Push Notifications

    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAp);

    //Local Notificaciones
  }

  static closeStreams() {
    _messageStream.close();
  }
}
