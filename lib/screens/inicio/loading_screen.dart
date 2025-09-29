import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../screens.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gpsProvider = Provider.of<PermissionsProvider>(context);

    return Scaffold(
      body: Center(
        child: gpsProvider.isReady
            ? (gpsProvider.isAllGranted)
                ? const LoginScreen()
                : const PermissionsAccessScreen()
            : Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 0),
              ),
      ),
    );
  }
}
