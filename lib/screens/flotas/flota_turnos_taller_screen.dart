import 'package:flutter/material.dart';

class FlotaTurnosTallerScreen extends StatelessWidget {
  const FlotaTurnosTallerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turnos Taller'), centerTitle: true),
      body: const Center(child: Text('Turnos Taller')),
    );
  }
}
