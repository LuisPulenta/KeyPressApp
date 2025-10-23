import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:keypressapp/config/local_notifications/local_notifications.dart';
import 'package:keypressapp/config/router/app_router.dart';
import 'package:keypressapp/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:keypressapp/providers/providers.dart';
import 'package:provider/provider.dart';

import 'config/theme/app_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Estas líneas son para que funcione el http con las direcciones https
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationsBloc.initializeFCM();
  await LocalNotifications.initializeLocalNotifications();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationsBloc(
            requestLocalNotificationPermissions:
                LocalNotifications.requestPermissionLocalNotification,
            showLocalNotification: LocalNotifications.showLocalNotification,
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PermissionsProvider(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => AppStateProvider(),
            lazy: false,
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Aseguramos que initializeHomeData se ejecute al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Inicializar los datos del estado
      context.read<AppStateProvider>().initializeHomeData();
    });

    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', '')],
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Keypress App',
      builder: (context, child) =>
          HandleNotificationInteraccions(child: child!),
    );
  }
}

class HandleNotificationInteraccions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteraccions({super.key, required this.child});

  @override
  State<HandleNotificationInteraccions> createState() =>
      _HandleNotificationInteraccionsState();
}

class _HandleNotificationInteraccionsState
    extends State<HandleNotificationInteraccions> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    final messageId = message.messageId
        ?.replaceAll(':', '')
        .replaceAll('%', '');
    appRouter.push('/push-details/$messageId');
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
