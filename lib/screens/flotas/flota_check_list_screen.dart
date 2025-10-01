import 'package:flutter/material.dart';

class FlotaCheckListScreen extends StatelessWidget {
  const FlotaCheckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check List'), centerTitle: true),
      body: const Center(child: Text('Check List')),
    );
  }
}
