import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keypressapp/config/router/app_router.dart';
import 'package:keypressapp/models/models.dart';
import 'package:keypressapp/presentation/blocs/notifications/notifications_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notificaciones'), centerTitle: true),
      body: const _NotificationsView(),
    );
  }
}

//-----------------------------------------------------------------------------
class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    // Cargar las notificaciones desde la base de datos
    context.read<NotificationsBloc>().add(LoadNotificationsFromDb());

    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final notifications = state.notifications;

        return ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Colors.black26, height: 2),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: _dismissBackground(),
              onDismissed: (direction) =>
                  onDeleteNotification(context, notification.messageId),
              child: _notificationTile(context, notification),
            );
          },
        );
      },
    );
  }

  // Método para crear el fondo del Dismissible
  Widget _dismissBackground() {
    return Container(
      color: Colors.red[400],
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
    );
  }

  // Método para crear el ListTile
  Widget _notificationTile(BuildContext context, PushMessage notification) {
    return ListTile(
      title: Text('Id: ${notification.id} - ${notification.title}'),
      subtitle: Text(
        'Fecha: ${DateFormat('dd/MM/yyyy').format(notification.sentDate)}',
        textAlign: TextAlign.left,
      ),
      leading: notification.imageUrl != null
          ? Image.network(notification.imageUrl!)
          : null,
      trailing: Icon(
        notification.readed ? Icons.done_outline : Icons.circle,
        color: notification.readed ? Colors.green : Colors.red,
        size: 14,
      ),
      onTap: () async {
        context.read<NotificationsBloc>().add(
          MarkNotificationAsRead(notification.id!),
        );
        await appRouter.push('/push-details/${notification.messageId}');
      },
    );
  }

  // Eliminar notificación
  void onDeleteNotification(BuildContext context, String messageId) {
    context.read<NotificationsBloc>().removeMessageBy(messageId);
  }
}
