import 'package:flutter/material.dart';

class ObrasRelevamientosScreen extends StatelessWidget {
  const ObrasRelevamientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relevamientos'), centerTitle: true),
      body: const Center(child: Text('Relevamientos')),
    );
  }
}
