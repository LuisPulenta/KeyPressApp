import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keypressapp/config/router/app_router.dart';

class LocalNotifications {
  //---------------------------------------------------------------------------------------
  static Future<void> requestPermissionLocalNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  //---------------------------------------------------------------------------------------
  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  //---------------------------------------------------------------------------------------
  static void showLocalNotification({
    required int id,
    String? messageId,
    String? sentDate,
    String? title,
    String? message,
    String? data,
    bool? readed,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.max,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final flutterLocalNotificactionsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificactionsPlugin.show(
      id,
      title,
      message,
      notificationDetails,
      payload: data,
    );
  }

  //---------------------------------------------------------------------------------------
  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    appRouter.push('/push-details/${response.payload}');
  }
}
