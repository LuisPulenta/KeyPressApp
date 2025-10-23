import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keypressapp/config/local_notifications/local_notifications.dart';
import 'package:keypressapp/firebase_options.dart';
import 'package:keypressapp/models/models.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  //print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushNumberId = 0;

  final Future<void> Function()? requestLocalNotificationPermissions;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })?
  showLocalNotification;

  NotificationsBloc({
    this.requestLocalNotificationPermissions,
    this.showLocalNotification,
  }) : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceiver>(_onPushMessageReceived);
    on<NotificationRemove>(_onNotificationRemove);

    initialStatusCheck();
    //Listener para notificaciones en Foreground
    _onForegroundMessage();
  }

  //-------------------------------------------------------------------------------
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //-------------------------------------------------------------------------------
  void initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
    getFCMToken();
  }

  //-------------------------------------------------------------------------------
  Future<String> getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return '';
    final token = await messaging.getToken();
    //print('Token: $token');
    return token ?? '';
  }

  //-------------------------------------------------------------------------------
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  //-------------------------------------------------------------------------------
  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      user: message.data['user'],
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );

    showLocalNotification!(
      id: ++pushNumberId,
      body: notification.body,
      data: notification.user,
      title: notification.title,
    );

    // if (showLocalNotification != null) {
    //   showLocalNotification!(
    //     id: ++pushNumberId,
    //     body: notification.body,
    //     data: notification.user,
    //     title: notification.title,
    //   );
    // }

    add(NotificationReceiver(notification));
    //print(notification);
  }

  //-------------------------------------------------------------------------------
  void _notificationStatusChanged(
    NotificationStatusChanged event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(status: event.status));
    getFCMToken();
  }

  //-------------------------------------------------------------------------------
  void _onPushMessageReceived(
    NotificationReceiver event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        notifications: [event.pushMessage, ...state.notifications],
      ),
    );
    print('NOTIFICACIONES: ${state.notifications.length}');
  }

  //----------------------------------------------------------------------------------
  void _onNotificationRemove(
    NotificationRemove event,
    Emitter<NotificationsState> emit,
  ) {
    // Crea una nueva lista eliminando el mensaje
    List<PushMessage> updatedMessages = List.from(state.notifications);
    updatedMessages.remove(event.removeMessage);

    // Emitir el nuevo estado con la lista actualizada
    emit(state.copyWith(notifications: updatedMessages));
  }

  //-------------------------------------------------------------------------------
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    if (requestLocalNotificationPermissions != null) {
      await requestLocalNotificationPermissions!();
    }
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  //-------------------------------------------------------------------------------
  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exist) return null;
    return state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
  }

  //----------------------------------------------------------------------------------
  void removeMessageBy(String pushMessageId) {
    final exist = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exist) return;
    PushMessage message = state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
    add(NotificationRemove(message));
  }
}
