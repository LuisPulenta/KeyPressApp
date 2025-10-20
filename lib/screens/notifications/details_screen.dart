import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keypressapp/models/models.dart';
import 'package:keypressapp/presentation/blocs/notifications/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;

  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessage? message = context
        .watch<NotificationsBloc>()
        .getMessageById(pushMessageId);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificación'), centerTitle: true),
      body: message != null
          ? _DetailsView(message: message)
          : const Center(child: Text('Notificación no existe')),
    );
  }
}

//------------------------ _DetailsView ------------------------
class _DetailsView extends StatelessWidget {
  final PushMessage message;
  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.imageUrl != null)
            Image.network(message.imageUrl!, width: 150),
          const SizedBox(height: 30),
          Text(
            'Fecha: ${DateFormat('dd/MM/yyyy').format(message.sentDate)}',
            textAlign: TextAlign.left,
          ),
          Text('Mensaje para el Usuario: ${message.user}'),
          const Divider(color: Colors.black),
          Text(
            message.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(message.body),
        ],
      ),
    );
  }
}
