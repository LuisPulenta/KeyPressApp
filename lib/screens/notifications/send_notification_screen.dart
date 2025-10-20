import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keypressapp/components/components.dart';
import 'package:keypressapp/helpers/helpers.dart';

import '../../models/models.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key});

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  //--------------------- Variables ------------------------
  bool _isloading = false;
  List<NotificationUser> _notificationUsers = [];
  List<UserToken> _userTokens = [];
  String _notificationUser = 'Elija un Usuario...';
  String _notificationUserError = '';
  bool _notificationUserShowError = false;

  String _title = '';
  String _titleError = '';
  bool _titleShowError = false;
  final TextEditingController _titleController = TextEditingController();

  String _message = '';
  String _messageError = '';
  bool _messageShowError = false;
  final TextEditingController _messageController = TextEditingController();
  String access_token = '';

  //--------------------- initState ------------------------
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //--------------------- _loadData ------------------------
  void _loadData() async {
    await _getNotificationUsers();
  }

  //--------------------- Pantalla -------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Notificación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            _isloading == true
                ? Center(child: LoaderComponent(text: 'Cargando Usuarios...'))
                : _notificationUsers.isEmpty
                ? Center(child: Text('No hay Usuarios'))
                : _showNotificationsUsers(),
            SizedBox(height: 10),
            _showTitle(),
            SizedBox(height: 10),
            _showMessage(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _sendMessage(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.send_to_mobile_rounded),
                    SizedBox(width: 20),
                    Text('Enviar Mensaje'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //------------------------------ _showTitle --------------------------
  Widget _showTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        controller: _titleController,
        maxLines: 1,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          hintText: 'Ingrese Título...',
          labelText: 'Título:',
          errorText: _titleShowError ? _titleError : null,
          prefixIcon: const Icon(Icons.title),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _title = value;
        },
      ),
    );
  }

  //------------------------------ _showMessage --------------------------
  Widget _showMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: TextField(
        controller: _messageController,
        maxLines: 10,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          hintText: 'Ingrese Mensaje...',
          labelText: 'Mensaje:',
          errorText: _messageShowError ? _messageError : null,
          prefixIcon: const Icon(Icons.chat),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _message = value;
        },
      ),
    );
  }

  //--------------------- _getNotificationUsers ------------
  Future<void> _getNotificationUsers() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        "Verifica que estés conectado a Internet",
        'Aceptar',
      );
      return;
    }

    _isloading = true;
    setState(() {});

    Response response = Response(isSuccess: false);
    response = await ApiHelper.getNotificationUsers();
    if (response.isSuccess) {
      _notificationUsers = response.result;
    }

    _isloading = false;
    setState(() {});
  }

  //--------------------- _showNotificationsUsers -----------------------

  Widget _showNotificationsUsers() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            child: _isloading
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Cargando Usuarios...'),
                    ],
                  )
                : _notificationUsers.isEmpty
                ? Row(
                    children: const [
                      Text(
                        'No hay Usuarios',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ],
                  )
                : DropdownButtonFormField(
                    initialValue: _notificationUser,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Elija un Usuario...',
                      labelText: 'Usuario',
                      errorText: _notificationUserShowError
                          ? _notificationUserError
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _getComboNotificationUsers(),
                    onChanged: (value) {
                      _notificationUser = value.toString();
                    },
                  ),
          ),
        ),
      ],
    );
  }

  //--------------------- _getComboTiposAsignacion ---------
  List<DropdownMenuItem<String>> _getComboNotificationUsers() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Usuario...',
        child: Text('Elija un Usuario...'),
      ),
    );

    for (var notificationUser in _notificationUsers) {
      list.add(
        DropdownMenuItem(
          value: notificationUser.usuario,
          child: Text(notificationUser.nombre),
        ),
      );
    }

    return list;
  }

  //--------------------- validateFields ----------------------------
  bool validateFields() {
    bool isValid = true;

    if (_notificationUser == 'Elija un Usuario...') {
      isValid = false;
      _notificationUserShowError = true;
      _notificationUserError = 'Debe seleccionar un Usuario';
    } else {
      _notificationUserShowError = false;
    }

    if (_title.isEmpty) {
      isValid = false;
      _titleShowError = true;
      _titleError = 'Debe ingresar un Título';
    } else {
      _titleShowError = false;
      _titleError = '';
    }

    if (_title.length <= 3) {
      isValid = false;
      _titleShowError = true;
      _titleError = 'El Título debe tener más de 3 caracteres';
    } else {
      _titleShowError = false;
      _titleError = '';
    }

    if (_message.isEmpty) {
      isValid = false;
      _messageShowError = true;
      _messageError = 'Debe ingresar un Mensaje';
    } else {
      _messageShowError = false;
      _messageError = '';
    }

    if (_message.length <= 3) {
      isValid = false;
      _messageShowError = true;
      _messageError = 'El Mensaje debe tener más de 3 caracteres';
    } else {
      _messageShowError = false;
      _messageError = '';
    }

    setState(() {});

    return isValid;
  }

  //--------------------- _sendMessage ------------------------------------
  void _sendMessage() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      await customErrorDialog(
        context,
        'Error',
        'Verifica que estés conectado a Internet',
      );
      return;
    }

    if (!validateFields()) {
      return;
    }

    //---------- Obtener el access_token ----------
    var response = await ApiHelper.getNotificationToken();
    access_token = response.result;

    //---------- Obtener los tokens del usuario seleccionado ----------
    response = await ApiHelper.getTokensByUser(_notificationUser);
    _userTokens = response.result;

    //---------- Envía mensaje a los tokens del Usuario seleccionado ----------

    for (var userToken in _userTokens) {
      Map<String, dynamic> request = {
        "message": {
          "token": userToken.token,
          "data": {"user": _notificationUser},
          "notification": {"title": _title, "body": _message},
          "android": {
            "notification": {
              "image":
                  "https://www.keypress.com.ar/img/LOGO_4_new_resolution_SLOGAN-removebg.png",
            },
          },
        },
      };

      var url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/projects-e6264/messages:send',
      );

      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': 'Bearer $access_token',
        },
        body: jsonEncode(request),
      );
      Navigator.pop(context);
    }
  }
}
