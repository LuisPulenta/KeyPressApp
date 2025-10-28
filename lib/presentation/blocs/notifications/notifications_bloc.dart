import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keypressapp/firebase_options.dart';
import 'package:keypressapp/models/models.dart';
import 'package:keypressapp/providers/db_provider.dart';
import 'package:keypressapp/shared_preferences/preferences.dart';

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
    int id,
    String messageId,
    String sentDate,
    String? title,
    String? body,
    String? data,
    bool readed,
  })?
  showLocalNotification;

  NotificationsBloc({
    this.requestLocalNotificationPermissions,
    this.showLocalNotification,
  }) : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceiver>(_onPushMessageReceived);
    on<NotificationRemove>(_onNotificationRemove);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<LoadNotificationsFromDb>(_loadNotificationsFromDB);

    initialStatusCheck();
    //Listener para notificaciones en Foreground
    _onForegroundMessage();
    loadNotificationsFromDB();
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
  Future<void> handleRemoteMessage(RemoteMessage message) async {
    if (message.notification == null) return;
    PushMessage notification = PushMessage(
      id: 0,
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

    final id = await DBProvider.db.newNotificationRaw(notification);
    notification = notification.copyWith(id: id);

    if (showLocalNotification != null) {
      showLocalNotification!(
        id: notification.id!,
        messageId: notification.messageId,
        sentDate: notification.sentDate.toString(),
        body: notification.body,
        data: notification.messageId,
        title: notification.title,
        readed: notification.readed,
      );
    }
    add(NotificationReceiver(notification));
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
  void removeMessageBy(String pushMessageId) async {
    final exist = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exist) return;
    PushMessage message = state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
    add(NotificationRemove(message));
    await DBProvider.db.deleteNotification(message.id!);
  }

  //----------------------------------------------------------------------------------
  Future<void> loadNotificationsFromDB() async {
    String user = User.fromJson(jsonDecode(Preferences.userBody)).login;
    if (user != '') {
      List<PushMessage> notifications = await DBProvider.db
          .getAllNotificationsByUser(user);
      emit(state.copyWith(notifications: notifications));
    }
  }

  //----------------------------------------------------------------------------------
  void _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    await DBProvider.db.markAsRead(event.notificationId);
    loadNotificationsFromDB();
  }

  //----------------------------------------------------------------------------------
  void _loadNotificationsFromDB(
    LoadNotificationsFromDb event,
    Emitter<NotificationsState> emit,
  ) async {
    loadNotificationsFromDB();
  }
}
