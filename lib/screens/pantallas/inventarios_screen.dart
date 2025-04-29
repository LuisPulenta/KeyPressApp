import 'package:flutter/material.dart';

class InventariosScreen extends StatelessWidget {
  const InventariosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventarios'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Inventarios'),
      ),
    );
  }
}
