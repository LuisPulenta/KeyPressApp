import 'package:flutter/material.dart';

class DefensaConsumidorScreen extends StatelessWidget {
  const DefensaConsumidorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defensa del Consumidor'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('DefensaConsumidorScreen'),
      ),
    );
  }
}
