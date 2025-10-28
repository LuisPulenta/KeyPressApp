part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationStatusChanged(this.status);
}

class NotificationReceiver extends NotificationsEvent {
  final PushMessage pushMessage;

  NotificationReceiver(this.pushMessage);
}

class NotificationRemove extends NotificationsEvent {
  final PushMessage removeMessage;

  NotificationRemove(this.removeMessage);
}

class MarkNotificationAsRead extends NotificationsEvent {
  final int notificationId;

  MarkNotificationAsRead(this.notificationId);
}

class LoadNotificationsFromDb extends NotificationsEvent {
  LoadNotificationsFromDb();
}
