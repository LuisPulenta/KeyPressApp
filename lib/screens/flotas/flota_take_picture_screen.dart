import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:keypressapp/models/models.dart';
import 'package:keypressapp/screens/screens.dart';

class FlotaTakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const FlotaTakePictureScreen({super.key, required this.camera});

  @override
  _FlotaTakePictureScreenState createState() => _FlotaTakePictureScreenState();
}

class _FlotaTakePictureScreenState extends State<FlotaTakePictureScreen> {
  //-----------------------------------------------------------------------------
  //----------------------------- Variables -------------------------------------
  //-----------------------------------------------------------------------------

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  //-----------------------------------------------------------------------------
  //----------------------------- initState -------------------------------------
  //-----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.low);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------------------------
  //----------------------------- Pantalla --------------------------------------
  //-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tomar Foto')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            Response? response = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FlotaDisplayPictureScreen(image: image),
              ),
            );
            if (response != null) {
              Navigator.pop(context, response);
            }
          } catch (e) {
            throw Exception('');
          }
        },
      ),
    );
  }
}
