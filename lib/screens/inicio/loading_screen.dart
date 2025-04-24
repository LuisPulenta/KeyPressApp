import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/gps/gps_bloc.dart';
import '../../themes/app_theme.dart';
import '../screens.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isReady
              ? state.isAllGranted
                  ? const LoginScreen()
                  : const GpsAccessScreen()
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primary,
                        AppTheme.secondary,
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
