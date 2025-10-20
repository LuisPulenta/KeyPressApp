import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../helpers/get_position.dart';
import '../../models/models.dart';

class DisplayPictureScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureScreen({Key? key, required this.image}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
//----------------------- Variables -----------------------------
  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;

  int _optionId = -1;
  String _optionIdError = '';
  bool _optionIdShowError = false;

  bool apretado = false;

  final List<String> _options = [
    'Relevamiento(Vereda/Calzada/Traza)',
    'Previa al trabajo',
    'Durante el trabajo',
    'Vereda conforme',
    'Finalización del Trabajo',
    'Proceso de geofonía',
    'Proceso de reparación'
  ];

//----------------------- Pantalla ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de la foto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              height: 440,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 300,
                    height: 440,
                    child: Image.file(
                      File(widget.image.path),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            _showOptions(),
            _showObservaciones(),
            _showButtons(),
          ],
        ),
      ),
    );
  }

//----------------------- _showOptions --------------------------
  Widget _showOptions() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          value: _optionId,
          onChanged: (option) {
            setState(() {
              _optionId = option as int;
            });
          },
          items: _getOptions(),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            hintText: 'Seleccione un Tipo de Foto...',
            labelText: '',
            fillColor: Colors.white,
            filled: true,
            errorText: _optionIdShowError ? _optionIdError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//----------------------- _showButtons --------------------------
  Widget _showButtons() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF120E43),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: !apretado
                    ? () {
                        setState(() {
                          apretado = true;
                        });
                        _usePhoto();
                      }
                    : null,
                child: const Text('Usar Foto'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE03B8B),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver a tomar'),
              ),
            ),
          ],
        ));
  }

//----------------------- _showObservaciones --------------------
  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Observaciones...',
            labelText: 'Observaciones',
            errorText: _observacionesShowError ? _observacionesError : null,
            prefixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

//----------------------- _usePhoto -----------------------------
  void _usePhoto() async {
    if (_optionId == -1) {
      _optionIdShowError = true;
      _optionIdError = 'Debe seleccionar un Tipo de Foto';
      setState(() {
        apretado = false;
      });
      return;
    } else {
      _optionIdShowError = false;
      setState(() {});
    }

    if (_optionId == -1) {
      setState(() {
        apretado = false;
      });
      return;
    }

    Position? position = await getPosition(context);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position!.latitude, position.longitude);

    Photo photo = Photo(
      image: widget.image,
      tipofoto: _optionId,
      observaciones: _observaciones,
      latitud: position.latitude,
      longitud: position.longitude,
      direccion: '${placemarks[0].street} - ${placemarks[0].locality}',
    );

    Response response = Response(isSuccess: true, result: photo);
    Future.delayed(const Duration(milliseconds: 100));
    Navigator.pop(context, response);
  }

  List<DropdownMenuItem<int>> _getOptions() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: -1,
      child: Text('Seleccione un Tipo de Foto...'),
    ));
    int nro = 0;
    int nro0 = 0;
    for (var element in _options) {
      //CORREGIR EL NUMERO PARA VEREDA CONFORME
      if (nro == 0) {
        nro0 = 0;
      }
      if (nro == 1) {
        nro0 = 1;
      }
      if (nro == 2) {
        nro0 = 2;
      }
      if (nro == 3) {
        nro0 = 10;
      }
      if (nro == 4) {
        nro0 = 3;
      }
      if (nro == 5) {
        nro0 = 5;
      }
      if (nro == 6) {
        nro0 = 6;
      }

      list.add(DropdownMenuItem(
        value: nro0,
        child: Text(element),
      ));
      nro++;
    }

    return list;
  }
}
