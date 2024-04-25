import 'dart:convert';

import 'package:keypressapp/models/models.dart';
import 'package:keypressapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keypressapp/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

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
  late User _user;
  late Empresa _empresa;

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
      debugShowCheckedModeBanner: false,
      title: 'Cascaron App',
      theme: AppTheme.lightTheme,
      home: _isLoading
          ? const WaitScreen()
          : _showLoginPage
              ? const LoginScreen()
              : HomeScreen(
                  user: _user,
                  empresa: _empresa,
                ),
    );
  }

//--------------------------- SharedPreferences -----------------------
  void _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isRemembered = prefs.getBool('isRemembered') ?? false;

    if (isRemembered) {
      String? userBody = prefs.getString('userBody');
      String? empresaBody = prefs.getString('empresaBody');
      String date = prefs.getString('date').toString();
      String dateAlmacenada = date.substring(0, 10);
      String dateActual = DateTime.now().toString().substring(0, 10);
      if (userBody != null) {
        var decodedJson = jsonDecode(userBody);
        var decodedJson2 = jsonDecode(empresaBody!);
        _user = User.fromJson(decodedJson);
        _empresa = Empresa.fromJson(decodedJson2);
        if (dateAlmacenada != dateActual) {
          _showLoginPage = true;
        } else {
          _showLoginPage = false;
        }
      }
    }

    _isLoading = false;
    setState(() {});
  }
}
