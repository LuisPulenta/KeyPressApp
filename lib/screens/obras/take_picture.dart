import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/response.dart';
import 'display_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool apretado = false;

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.low,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomar Foto'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: apretado == false
            ? () async {
                try {
                  setState(() {
                    apretado = true;
                  });
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  Response? response =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                                image: image,
                              )));
                  setState(() {
                    apretado = false;
                  });
                  if (response != null) {
                    Navigator.pop(context, response);
                  }
                } catch (e) {
                  throw Exception('');
                }
              }
            : null,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
