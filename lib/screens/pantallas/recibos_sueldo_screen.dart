import 'package:flutter/material.dart';

class RecibosSueldoScreen extends StatelessWidget {
  const RecibosSueldoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recibos Sueldo'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Recibos Sueldo'),
      ),
    );
  }
}
