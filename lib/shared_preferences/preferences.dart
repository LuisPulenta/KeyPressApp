import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String _connection = '';
  static String _userBody = '';
  static String _company = '';
  static String _empresa = '';
  static String _date = '';
  static bool _isRemembered = false;
  static int _nroConexion = 0;

  //----------------------------------------------------
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //----------------------------------------------------
  static String get connection {
    return _prefs.getString('connection') ?? _connection;
  }

  static set connection(String connection) {
    _connection = connection;
    _prefs.setString('connection', connection);
  }

  //----------------------------------------------------
  static String get userBody {
    return _prefs.getString('userBody') ?? _userBody;
  }

  static set userBody(String userBody) {
    _userBody = userBody;
    _prefs.setString('userBody', userBody);
  }

  //----------------------------------------------------
  static String get company {
    return _prefs.getString('company') ?? _company;
  }

  static set company(String company) {
    _company = company;
    _prefs.setString('company', company);
  }

  //----------------------------------------------------
  static String get empresa {
    return _prefs.getString('empresa') ?? _empresa;
  }

  static set empresa(String empresa) {
    _empresa = empresa;
    _prefs.setString('empresa', empresa);
  }

  //----------------------------------------------------
  static String get date {
    return _prefs.getString('date') ?? _date;
  }

  static set date(String date) {
    _date = date;
    _prefs.setString('date', date);
  }

  //----------------------------------------------------
  static bool get isRemembered {
    return _prefs.getBool('isRemembered') ?? _isRemembered;
  }

  static set isRemembered(bool isRemembered) {
    _isRemembered = isRemembered;
    _prefs.setBool('isRemembered', isRemembered);
  }

  //----------------------------------------------------
  static int get nroConexion {
    return _prefs.getInt('nroConexion') ?? _nroConexion;
  }

  static set nroConexion(int nroConexion) {
    _nroConexion = nroConexion;
    _prefs.setInt('nroConexion', nroConexion);
  }
}
