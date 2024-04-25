import 'package:flutter/material.dart';

class ObrasScreen extends StatelessWidget {
  const ObrasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obras'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Obras'),
      ),
    );
  }
}
