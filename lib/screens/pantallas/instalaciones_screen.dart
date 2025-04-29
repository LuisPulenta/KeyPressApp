import 'package:flutter/material.dart';

class InstalacionesScreen extends StatelessWidget {
  const InstalacionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instalaciones'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Instalaciones'),
      ),
    );
  }
}
