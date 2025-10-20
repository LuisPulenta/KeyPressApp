import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keypressapp/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:keypressapp/screens/screens.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc) =>
              Text('${bloc.state.status}', style: TextStyle(fontSize: 16)),
        ),

        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationsBloc>().requestPermission();
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _NotificationsView(context),
    );
  }
}

//-----------------------------------------------------------------------------
class _NotificationsView extends StatelessWidget {
  final BuildContext context2;
  const _NotificationsView(this.context2);

  @override
  Widget build(context2) {
    final notifications = context2
        .watch<NotificationsBloc>()
        .state
        .notifications;

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context2, index) {
        final notification = notifications[index];
        return ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.body),
          leading: notification.imageUrl != null
              ? Image.network(notification.imageUrl!)
              : null,
          onTap: () async {
            await Navigator.of(context2).push(
              MaterialPageRoute(
                builder: (context2) =>
                    DetailsScreen(pushMessageId: notification.messageId),
              ),
            );
          },
        );
      },
    );
  }
}
