import 'package:go_router/go_router.dart';
import 'package:keypressapp/main.dart';
import 'package:keypressapp/providers/app_state_provider.dart';
import 'package:keypressapp/screens/screens.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/', // Define initial location
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final appState = context
            .watch<AppStateProvider>(); // Usamos AppState desde el contexto

        return appState.isLoading
            ? const WaitScreen()
            : appState.showCompanyPage
            ? const CompanyScreen()
            : appState.showLoginPage
            ? const LoadingScreen()
            : HomeScreen();
      },
    ),
    GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) {
        return DetailsScreen(
          pushMessageId: state.pathParameters['messageId'] ?? '404',
        );
      },
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) {
        return LoadingScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return LoginScreen();
      },
    ),
    GoRoute(
      path: '/candado',
      builder: (context, state) {
        return CandadoScreen();
      },
    ),
    GoRoute(
      path: '/company',
      builder: (context, state) {
        return CompanyScreen();
      },
    ),
    GoRoute(
      path: '/terminos',
      builder: (context, state) {
        return TerminosScreen();
      },
    ),
    GoRoute(
      path: '/privacidad',
      builder: (context, state) {
        return PrivacidadScreen();
      },
    ),
    GoRoute(
      path: '/defensaconsumidor',
      builder: (context, state) {
        return DefensaConsumidorScreen();
      },
    ),
    GoRoute(
      path: '/notificaciones',
      builder: (context, state) {
        return NotificationsScreen();
      },
    ),
    GoRoute(
      path: '/enviarnotificacion',
      builder: (context, state) {
        return SendNotificationScreen();
      },
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) {
        return HomeScreen();
      },
    ),

    GoRoute(
      path: '/obrasmenu',
      builder: (context, state) {
        return ObrasMenuScreen();
      },
    ),

    GoRoute(
      path: '/obras',
      builder: (context, state) {
        return ObrasScreen();
      },
    ),

    GoRoute(
      path: '/obrasrelevamienros',
      builder: (context, state) {
        return ObrasRelevamientosScreen();
      },
    ),

    GoRoute(
      path: '/compras',
      builder: (context, state) {
        return ComprasScreen();
      },
    ),

    GoRoute(
      path: '/instalaciones',
      builder: (context, state) {
        return InstalacionesScreen();
      },
    ),

    GoRoute(
      path: '/flota',
      builder: (context, state) {
        return FlotaMenuScreen();
      },
    ),

    GoRoute(
      path: '/flotakmpreventivo',
      builder: (context, state) {
        return FlotaKmPreventivoScreen();
      },
    ),

    GoRoute(
      path: '/flotachecklisy',
      builder: (context, state) {
        return FlotaCheckListScreen();
      },
    ),

    GoRoute(
      path: '/flotaturnostaller',
      builder: (context, state) {
        return FlotaTurnosTallerScreen();
      },
    ),

    GoRoute(
      path: '/flotaturnosagregar',
      builder: (context, state) {
        return FlotaTurnosAgregarScreen();
      },
    ),

    GoRoute(
      path: '/rrhh',
      builder: (context, state) {
        return RrhhScreen();
      },
    ),

    GoRoute(
      path: '/recibossuledo',
      builder: (context, state) {
        return RecibosSueldoScreen();
      },
    ),
  ],
);



// import 'package:go_router/go_router.dart';
// import 'package:keypressapp/main.dart';
// import 'package:keypressapp/screens/screens.dart';

// // Aquí se define el router con el navigatorKey
// final appRouter = GoRouter(
//   navigatorKey: navigatorKey, // Pasamos el navigatorKey
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const NotificationsScreen(),
//     ),
    
//     GoRoute(
//       path: '/push-details/:messageId',
//       builder: (context, state) => DetailsScreen(
//         pushMessageId: state.pathParameters['messageId'] ?? '404',
//       ),
//     ),
//   ],
// );
