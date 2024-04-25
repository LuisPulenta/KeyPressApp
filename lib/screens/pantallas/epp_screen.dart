import 'package:flutter/material.dart';

class EppScreen extends StatelessWidget {
  const EppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Epp'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Epp'),
      ),
    );
  }
}
