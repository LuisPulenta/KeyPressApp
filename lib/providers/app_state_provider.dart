import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:keypressapp/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helpers.dart';

class AppStateProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _showLoginPage = true;
  bool _showCompanyPage = true;
  late User _user;
  late Empresa _empresa;

  bool get isLoading => _isLoading;
  bool get showLoginPage => _showLoginPage;
  bool get showCompanyPage => _showCompanyPage;
  User get user => _user;
  Empresa get empresa => _empresa;

  //-------------------------------------------------------------------------------
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //-------------------------------------------------------------------------------
  void setShowCompanyPage(bool value) {
    _showCompanyPage = value;
    notifyListeners();
  }

  //-------------------------------------------------------------------------------
  void setShowLoginPage(bool value) {
    _showLoginPage = value;
    notifyListeners();
  }

  //-------------------------------------------------------------------------------
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  //-------------------------------------------------------------------------------
  void setEmpresa(Empresa empresa) {
    _empresa = empresa;
    notifyListeners();
  }

  //-------------------------------------------------------------------------------
  Future<void> initializeHomeData() async {
    // Cargar los datos de SharedPreferences y configurar el estado
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRemembered = prefs.getBool('isRemembered') ?? false;
    String companySelected = prefs.getString('company') ?? '';

    if (companySelected.isEmpty) {
      setShowCompanyPage(true);
    } else {
      setShowCompanyPage(false);
      if (isRemembered) {
        String? userBody = prefs.getString('userBody');
        String date = prefs.getString('date').toString();
        String dateAlmacenada = date.substring(0, 10);
        String dateActual = DateTime.now().toString().substring(0, 10);
        if (userBody != null && userBody != '') {
          var decodedJson = jsonDecode(userBody);
          setUser(User.fromJson(decodedJson));
          setShowLoginPage(dateAlmacenada != dateActual);
        }
      }
    }
    setIsLoading(false);
    _getEmpresa(companySelected);
  }

  //-------------------------------------------------------------------------------
  Future<void> _getEmpresa(String company) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return;
    }

    Response response = await ApiHelper.getEmpresa(company);
    if (!response.isSuccess) {
      return;
    }
    setEmpresa(response.result);
  }
}
