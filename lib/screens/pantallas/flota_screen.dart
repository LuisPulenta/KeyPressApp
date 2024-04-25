import 'package:flutter/material.dart';

class FlotaScreen extends StatelessWidget {
  const FlotaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flota'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Flota'),
      ),
    );
  }
}
