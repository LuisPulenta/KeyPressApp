import 'package:flutter/material.dart';

class PrivacidadScreen extends StatelessWidget {
  const PrivacidadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacidad'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('PrivacidadScreen'),
      ),
    );
  }
}
