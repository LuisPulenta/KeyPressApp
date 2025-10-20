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
