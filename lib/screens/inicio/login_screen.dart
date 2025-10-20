import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:device_information/device_information.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:http/http.dart' as http;
import 'package:keypressapp/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../themes/app_theme.dart';
import '../screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //----------------------- Variables -----------------------------

  // String _email = '';
  // String _password = '';

  // String _email = 'GPRIETO';
  // String _password = 'CELESTE';

  String _email = 'KEYPRESS';
  String _password = 'KEYROOT';

  String _emailError = '';
  bool _emailShowError = false;

  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;
  bool _passwordShow = false;
  bool _showLoader = false;

  String companySelected = '';
  String connectionSelected = '';
  Empresa? _empresa;

  String _imeiNo = '';
  bool _hayPermisoPhone = false;
  bool _hayPermisoCamera = false;
  bool _hayPermisoLocation = false;

  //----------------------- initState -----------------------------
  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getData();
    setState(() {});
  }

  //--------------------- hayPermisoPhone -------------------------
  Future<bool> hayPermisoPhone() async {
    var statusPhone = await Permission.phone.status;
    if (statusPhone.isDenied) {
      return false;
    }
    return true;
  }

  //--------------------- hayPermisoCamera -------------------------
  Future<bool> hayPermisoCamera() async {
    var statusCamera = await Permission.camera.status;
    if (statusCamera.isDenied) {
      return false;
    }
    return true;
  }

  //--------------------- hayPermisoLocation -------------------------
  Future<bool> hayPermisoLocation() async {
    var statusLocation = await Permission.location.status;
    if (statusLocation.isDenied) {
      return false;
    }
    return true;
  }

  //--------------------- hayImei -------------------------
  bool hayImei() {
    return _imeiNo != '';
  }

  //--------------------- recuperarImei -------------------------
  Future<void> recuperarImei() async {
    late String imeiNo = '';
    try {
      imeiNo = await FlutterDeviceImei.instance.getIMEI() ?? '';
    } on PlatformException {
      imeiNo = 'Sin Imei';
    }
    if (!mounted) return;
    _imeiNo = imeiNo;
    setState(() {});
  }

  //--------------------- initPlatformState -------------------------
  Future<void> initPlatformState() async {
    _hayPermisoCamera = await hayPermisoCamera();
    _hayPermisoPhone = await hayPermisoPhone();
    _hayPermisoLocation = await hayPermisoLocation();

    if (_hayPermisoPhone) {
      await recuperarImei();
    }

    if (!_hayPermisoCamera || !_hayPermisoPhone || !_hayPermisoLocation) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('La App necesita que habilite los Permisos de:'),
                !_hayPermisoCamera ? const Text('- Cámara') : Container(),
                !_hayPermisoPhone ? const Text('- Teléfono') : Container(),
                !_hayPermisoLocation ? const Text('- Ubicación') : Container(),
                const SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      openAppSettings();
    }
  }

  //----------------------- dispose ------------------------------
  @override
  void dispose() {
    super.dispose();
  }

  //----------------------- _getData ------------------------------
  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companySelected = prefs.getString('company') ?? '';
    connectionSelected = prefs.getString('connection') ?? '';
    setState(() {});
    _getEmpresa();
  }

  //------------------------------ _getEmpresa --------------------------
  Future<void> _getEmpresa() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await customErrorDialog(
        context,
        'Error',
        'Verifica que estés conectado a Internet',
      );
      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Verifica que estes conectado a internet.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    Response response = await ApiHelper.getEmpresa(companySelected);

    if (!response.isSuccess) {
      await customErrorDialog(
        context,
        'Error',
        'Hubo un error al recuperar los datos',
      );

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Hubo un error al recuperar ls datos',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);

      setState(() {});
      return;
    }
    _empresa = response.result;
  }
  //----------------------- Pantalla ------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CandadoScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 0),
              color: Colors.white,
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [
              //       AppTheme.primary,
              //       AppTheme.secondary,
              //     ],
              //   ),
              // ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 150,
                          width: 350,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Constants.version,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      companySelected,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      color: const Color.fromARGB(255, 203, 222, 241),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _showEmail(),
                            _showPassword(),
                            const SizedBox(height: 10),
                            _showRememberme(),
                            _showButton(),
                          ],
                        ),
                      ),
                    ),

                    //----------------------------------------------------
                    // TextButton(
                    //     onPressed: () async {
                    //       bool result = await showConfirmDialog(context,
                    //           title: 'Atención!',
                    //           content: 'Está seguro de cambiar de empresa?');
                    //       if (result) {
                    //         await Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const CompanyScreen(),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //     child: const Text('Cambiar de Empresa',
                    //         style: TextStyle(color: Colors.white, fontSize: 20))),

                    //----------------------------------------------------
                    // TextButton(
                    //     onPressed: () async {
                    //       await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const UsersExample(),
                    //         ),
                    //       );
                    //     },
                    //     child: const Text('Usuarios de Ejemplo',
                    //         style: TextStyle(
                    //             color: AppTheme.primary, fontSize: 20))),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[SizedBox(height: 40)],
              ),
            ),
            _showLoader
                ? const LoaderComponent(text: 'Por favor espere...')
                : Container(),
          ],
        ),
      ),
    );
  }

  //--------------------- _showEmail --------------------------------
  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Usuario...',
          labelText: 'Usuario',
          errorText: _emailShowError ? _emailError : null,
          prefixIcon: const Icon(Icons.person),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  //--------------------- _showPassword -----------------------------
  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Contraseña...',
          labelText: 'Contraseña',
          errorText: _passwordShowError ? _passwordError : null,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  //--------------------- _showRememberme ---------------------------
  CheckboxListTile _showRememberme() {
    return CheckboxListTile(
      title: const Text('Recordarme:'),
      value: _rememberme,
      activeColor: AppTheme.primary,
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

  //--------------------- _showButton -------------------------------
  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _login(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login),
                  SizedBox(width: 20),
                  Text('Iniciar Sesión'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------- validateFields ----------------------------
  bool validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Usuario';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu Contraseña';
    } else if (_password.length < 6) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'La Contraseña debe tener al menos 6 caracteres';
    } else {
      _passwordShowError = false;
    }

    setState(() {});

    return isValid;
  }

  //--------------------- _login ------------------------------------
  void _login() async {
    final notificationsBloc = context.read<NotificationsBloc>();
    FocusScope.of(context).unfocus(); //Oculta el teclado

    if (!hayImei()) {
      initPlatformState();
      return;
    }

    setState(() {
      _passwordShow = false;
    });

    if (!validateFields()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });

      await customErrorDialog(
        context,
        'Error',
        'Verifica que estés conectado a Internet',
      );

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Verifica que estes conectado a internet.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    Map<String, dynamic> request = {'Email': _email, 'Password': _password};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString('connection') ?? '';

    var url = Uri.parse('$apiUrl/Api/Account/GetUserByEmail');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
        _showLoader = false;
      });
      return;
    }

    var body = response.body;

    if (body == '') {
      setState(() {
        _emailShowError = true;
        _emailError = 'Usuario inexistente';
        _showLoader = false;
      });
      return;
    }

    var decodedJson = jsonDecode(body);
    var user = User.fromJson(decodedJson);

    if (user.contrasena.toLowerCase() != _password.toLowerCase()) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
      });
      return;
    }

    if (_empresa!.habilitaEmpresa == 0) {
      setState(() {
        _showLoader = false;
        _emailShowError = true;
        _emailError = 'Usuario de Empresa no habilitada';
        _passwordShowError = true;
        _passwordError = 'Usuario de Empresa no habilitada';
      });
      return;
    }

    if (user.habilitaAPP != 1) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Usuario no habilitado';
      });
      return;
    }

    if (user.estado != 1) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Usuario desactivado';
      });
      return;
    }

    // Agregar registro a  websesion

    Random r = Random();
    int resultado = r.nextInt((99999999 - 10000000) + 1) + 10000000;
    double hora =
        (DateTime.now().hour * 3600 +
            DateTime.now().minute * 60 +
            DateTime.now().second +
            DateTime.now().millisecond * 0.001) *
        100;

    WebSesion webSesion = WebSesion(
      nroConexion: resultado,
      usuario: user.idUsuario.toString(),
      iP: _imeiNo,
      loginDate: DateTime.now().toString().substring(0, 10),
      loginTime: hora.round(),
      modulo: 'App-${user.codigoCausante}',
      logoutDate: null,
      logoutTime: 0,
      conectAverage: 0,
      id_ws: 0,
      versionsistema: Constants.version,
    );

    await _postWebSesion(webSesion);

    await prefs.setInt('nroConexion', resultado);

    //---------- Registra Token Notification ----------

    notificationsBloc.initialStatusCheck();
    String token = await notificationsBloc.getFCMToken();

    if (token != '') {
      Map<String, dynamic> usuarioTokenRequest = {
        'usuario': user.login,
        'token': token,
      };

      await ApiHelper.postNoToken(
        '/api/UsuarioTokens/RegisterToken',
        usuarioTokenRequest,
      );
    }

    //---------- Va a la página Home ----------
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: user, empresa: _empresa!),
      ),
    );
  }

  //--------------------- _postWebSesion ----------------------------
  Future<void> _postWebSesion(WebSesion webSesion) async {
    Map<String, dynamic> requestWebSesion = {
      'nroConexion': webSesion.nroConexion,
      'usuario': webSesion.usuario,
      'iP': webSesion.iP,
      'loginDate': webSesion.loginDate,
      'loginTime': webSesion.loginTime,
      'modulo': webSesion.modulo,
      'logoutDate': webSesion.logoutDate,
      'logoutTime': webSesion.logoutTime,
      'conectAverage': webSesion.conectAverage,
      'id_ws': webSesion.id_ws,
      'versionsistema': webSesion.versionsistema,
    };

    await ApiHelper.post('/api/WebSesions/', requestWebSesion);
  }
}
