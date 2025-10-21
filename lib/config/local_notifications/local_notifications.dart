import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  //------------------------------------------------------------------------------------------
  static Future<void> requestPermissionLocalNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  //------------------------------------------------------------------------------------------
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

  //------------------------------------------------------------------------------------------
  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final flutterLocalNotificactionsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificactionsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: data,
    );
  }

  static void onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) async {
    // appRouter.push('/push-details/${ response.payload }');

    //   await Navigator.of(context).push(
    //           MaterialPageRoute(
    //             builder: (context2) =>
    //                 DetailsScreen(pushMessageId: response.payload!),
    //           ),
    //         );
  }
}
