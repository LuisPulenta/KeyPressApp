import 'package:flutter/material.dart';

import '../../models/models.dart';

class ObrasRelevamientosScreen extends StatelessWidget {
  final User user;
  const ObrasRelevamientosScreen({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevamientos'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Relevamientos'),
      ),
    );
  }
}
