import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/gps/gps_bloc.dart';
import 'models/models.dart';
import 'screens/screens.dart';
import 'themes/app_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  //Estas líneas son para que funcione el http con las direcciones https
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => GpsBloc()),
  ], child: const MyApp()));
}

//--------------------------------------------------------------------------
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

//--------------------------------------------------------------------------
class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showLoginPage = true;
  bool _showCompanyPage = true;
  late User _user;

  //--------------------------- initState ----------------------------------
  @override
  void initState() {
    super.initState();
    _getHome();
  }

//--------------------------- Pantalla ----------------------------------
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Keypress App',
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      home: _isLoading
          ? const WaitScreen()
          : _showCompanyPage
              ? const CompanyScreen()
              : _showLoginPage
                  ? const LoadingScreen()
                  : HomeScreen(
                      user: _user,
                    ),
    );
  }

//--------------------------- SharedPreferences -----------------------
  void _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isRemembered = prefs.getBool('isRemembered') ?? false;
    String companySelected = prefs.getString('company') ?? '';

    if (companySelected.isEmpty) {
      _showCompanyPage = true;
    } else {
      _showCompanyPage = false;
      if (isRemembered) {
        String? userBody = prefs.getString('userBody');
        String date = prefs.getString('date').toString();
        String dateAlmacenada = date.substring(0, 10);
        String dateActual = DateTime.now().toString().substring(0, 10);
        if (userBody != null && userBody != '') {
          var decodedJson = jsonDecode(userBody);
          _user = User.fromJson(decodedJson);
          if (dateAlmacenada != dateActual) {
            _showLoginPage = true;
          } else {
            _showLoginPage = false;
          }
        }
      }
    }

    _isLoading = false;
    setState(() {});
  }
}
