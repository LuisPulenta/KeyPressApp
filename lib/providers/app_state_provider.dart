import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:keypressapp/models/models.dart';
import 'package:keypressapp/shared_preferences/preferences.dart';

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
    String companySelected = Preferences.company;
    bool isRemembered = Preferences.isRemembered;

    await _getEmpresa(companySelected);

    if (companySelected.isEmpty) {
      setShowCompanyPage(true);
    } else {
      setShowCompanyPage(false);
      if (isRemembered) {
        String? userBody = Preferences.userBody;
        String? empresa = Preferences.empresa;
        String date = Preferences.date;
        String dateAlmacenada = date.substring(0, 10);
        String dateActual = DateTime.now().toString().substring(0, 10);
        if (userBody != '' && empresa != '') {
          var decodedJson = jsonDecode(userBody);
          setUser(User.fromJson(decodedJson));
          if (dateAlmacenada != dateActual) {
            setShowLoginPage(true);
          } else {
            setShowLoginPage(false);
          }
        }
      }
    }
    setIsLoading(false);
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
