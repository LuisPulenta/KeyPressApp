import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../themes/app_theme.dart';
import '../screens.dart';

class ObraInfoScreen extends StatefulWidget {
  final User user;
  final Obra obra;

  const ObraInfoScreen({
    Key? key,
    required this.user,
    required this.obra,
  }) : super(key: key);

  @override
  _ObraInfoScreenState createState() => _ObraInfoScreenState();
}

class _ObraInfoScreenState extends State<ObraInfoScreen> {
//----------------------- Variables -----------------------------
  bool _photoChanged = false;
  late XFile _image;

  late Photo _photo;
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  final bool _showLoader = false;

  Obra _obra = Obra(
      nroObra: 0,
      nombreObra: '',
      nroOE: '',
      defProy: '',
      central: '',
      elempep: '',
      observaciones: '',
      finalizada: 0,
      supervisore: '',
      codigoEstado: '',
      codigoSubEstado: '',
      modulo: '',
      grupoAlmacen: '',
      obrasDocumentos: [],
      fechaCierreElectrico: '',
      fechaUltimoMovimiento: '',
      photos: 0,
      posx: '',
      posy: '',
      direccion: '',
      textoLocalizacion: '',
      textoClase: '',
      textoTipo: '',
      textoComponente: '',
      codigoDiametro: '',
      motivo: '',
      planos: '',
      grupoCausante: '');

  List<ObrasDocumento> _obrasDocumentos = [];
  List<ObrasDocumento> _obrasDocumentosFotos = [];

//----------------------- initState -----------------------------
  @override
  void initState() {
    super.initState();
    _obra = widget.obra;
    _getObra();
  }

//----------------------- Pantalla -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Obra ${widget.obra.nroObra}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _getInfoObra(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _obrasDocumentosFotos.isNotEmpty
                          // ? Container(
                          //     width: 300,
                          //     height: 200,
                          //     color: Colors.amberAccent,
                          //     child:
                          //         Text(_obrasDocumentosFotos.length.toString()),
                          //   )
                          ? _showPhotosCarousel()
                          : Container(),
                    ],
                  ),
                ),
              ),
              _showImageButtons(),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

//-------------------------- _getInfoObra -------------------------------
  Widget _getInfoObra() {
    var f = NumberFormat('#,###', 'es');
    return Card(
      color: const Color.fromARGB(255, 203, 222, 241),
      shadowColor: const Color(0xFFC7C7C8),
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Text('N° Obra: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  flex: 3,
                  child: Text(f.format(_obra.nroObra).toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ),
                const Text('Ult.Mov.: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  flex: 4,
                  child: _obra.fechaUltimoMovimiento != null
                      ? Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(
                              _obra.fechaUltimoMovimiento.toString())),
                          style: const TextStyle(
                            fontSize: 12,
                          ))
                      : Container(),
                ),
                // const Text('Módulo: ',
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: AppTheme.primary,
                //       fontWeight: FontWeight.bold,
                //     )),
                // Expanded(
                //   flex: 4,
                //   child: Text(_obra.modulo.toString(),
                //       style: const TextStyle(
                //         fontSize: 12,
                //       )),
                // ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text('Nombre: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  child: Text(_obra.nombreObra,
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text('OP/N° Fuga: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  child: Text(_obra.elempep,
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

//-------------------------- _showPhotosCarousel ------------------------
  Widget _showPhotosCarousel() {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
                height: size.height * 0.65,
                autoPlay: false,
                initialPage: 0,
                autoPlayInterval: const Duration(seconds: 0),
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            carouselController: _carouselController,
            items: _obrasDocumentosFotos.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      // onTap: () {
                      //     NotificationsService.showImage(
                      //       context, i.photoFullPath);
                      // },

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return Stack(
                                    children: [
                                      InteractiveViewer(
                                        boundaryMargin: const EdgeInsets.all(
                                            double.infinity),
                                        child: SizedBox(
                                          width: size.width,
                                          height: size.height,
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/loading.gif',
                                            image: i.imageFullPath!,
                                            fit: BoxFit.contain,
                                            width: size.width,
                                            height: size.height,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: size.height * 0.08,
                                          right: 5,
                                          child: IconButton(
                                            icon: const Icon(
                                              FontAwesomeIcons.rectangleXmark,
                                              color: Colors.red,
                                              size: 36,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: i.imageFullPath.toString(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  height: 660,
                                  width: 560,
                                  placeholder: (context, url) => const Image(
                                    image: AssetImage('assets/loading.gif'),
                                    fit: BoxFit.contain,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              )),
                        ),
                      ),

                      Text(
                        i.tipoDeFoto == 0
                            ? 'Relevamiento(Vereda/Calzada/Traza)'
                            : i.tipoDeFoto == 1
                                ? 'Previa al trabajo'
                                : i.tipoDeFoto == 2
                                    ? 'Durante el trabajo'
                                    : i.tipoDeFoto == 3
                                        ? 'Vereda conforme'
                                        : i.tipoDeFoto == 4
                                            ? 'Finalización del Trabajo'
                                            : i.tipoDeFoto == 5
                                                ? 'Proceso de geofonía'
                                                : i.tipoDeFoto == 6
                                                    ? 'Proceso de reparación'
                                                    : '',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _obrasDocumentosFotos.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

//-------------------------- _showImageButtons --------------------------
  Widget _showImageButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF120E43),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () => _goAddPhoto(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.add_a_photo),
                      Text('Adic. Foto'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB4161B),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () => _confirmDeletePhoto(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.delete),
                      Text('Elim. Foto'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 0,
              ),
            ]),
      ]),
    );
  }

//-------------------------- _goAddPhoto --------------------------
  void _goAddPhoto() async {
    if (widget.user.habilitaFotos != 1) {
      await customErrorDialog(context, 'Error',
          'Su usuario no está habilitado para agregar Fotos.');

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Su usuario no está habilitado para agregar Fotos.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    if (widget.obra.finalizada == 1) {
      await customErrorDialog(
          context, 'Error', 'Obra Terminada. No se puede agregar fotos.');
      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Obra Terminada. No se puede agregar fotos.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    // var response = await showAlertDialog(
    //     context: context,
    //     title: 'Confirmación',
    //     message: '¿De donde deseas obtener la imagen?',
    //     actions: <AlertDialogAction>[
    //       const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
    //       const AlertDialogAction(key: 'camera', label: 'Cámara'),
    //       const AlertDialogAction(key: 'gallery', label: 'Galería'),
    //     ]);

    //await customErrorDialog(context, 'Error', 'Usted es un desubicado!!');
    //await customWarningDialog(context, 'Atención', 'Algo no está bien!!');
    //await customSuccessDialog(context, 'Perfecto!!', 'Guardado sin problemas!!');

    var response = await customQuestionDialog(context,
        content: 'Desde dónde desea sacar la foto?',
        title1: 'Cámara',
        title2: 'Galería',
        option1: 'camera',
        option2: 'gallery');

    if (response == 'cancel') {
      return;
    }

    if (response == 'camera') {
      await _takePicture();
    } else {
      await _selectPicture();
    }

    if (_photoChanged) {
      _addPicture();
    } else {
      _photoChanged = false;
    }
  }

//------------------------------ _takePicture ---------------------------------
  Future _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;

    var response1 = await customQuestionDialog(context,
        content: '¿Qué cámara desea utilizar?',
        title1: 'Trasera',
        title2: 'Delantera',
        option1: 'no',
        option2: 'yes');

    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _photo = response.result;
          _image = _photo.image;
        });
      }
    }
  }

//------------------------------ _selectPicture -------------------------------
  Future<void> _selectPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image2 = await picker.pickImage(source: ImageSource.gallery);

    if (image2 != null) {
      //_photoChanged = true;
      Response? response = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
                image: image2,
              )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _photo = response.result;
          _image = _photo.image;
        });
      }
    }
  }

//------------------------------ _addPicture ----------------------------------
  void _addPicture() async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});

      await customErrorDialog(
          context, 'Error', 'Verifica que estés conectado a Internet');
      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Verifica que estes conectado a internet.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    List<int> imageBytes = await _image.readAsBytes();

    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> request = {
      'imagearray': base64Image,
      'fecha': DateTime.now().toString().substring(0, 10),
      'nroobra': _obra.nroObra,
      'observacion': _photo.observaciones,
      'estante': 'App',
      'generadopor': widget.user.login,
      'modulo': widget.user.modulo,
      'nrolote': 'App',
      'sector': 'App',
      'latitud': _photo.latitud,
      'longitud': _photo.longitud,
      'tipodefoto': _photo.tipofoto,
      'direccionfoto': _photo.direccion,
      'obra': _obra,
    };

    Response response =
        await ApiHelper.post('/api/ObrasDocuments/ObrasDocument', request);

    setState(() {});

    if (!response.isSuccess) {
      await customErrorDialog(context, 'Error', response.message);

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: response.message,
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    setState(() {
      _getObra();
    });
  }

//------------------------------ _confirmDeletePhoto --------------------------
  void _confirmDeletePhoto() async {
    if (_obrasDocumentosFotos.isEmpty) {
      return;
    }

    if (widget.obra.finalizada == 1) {
      await customErrorDialog(
          context, 'Error', 'Obra Terminada. No se puede eliminar fotos.');

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Obra Terminada. No se puede eliminar fotos.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    if (widget.user.habilitaFotos != 1) {
      await customErrorDialog(context, 'Error',
          'Su usuario no está habilitado para eliminar Fotos.');

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Su usuario no está habilitado para eliminar Fotos.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    if (widget.user.login != _obra.obrasDocumentos[_current].generadoPor) {
      await customErrorDialog(context, 'Error',
          'Esta foto (NROREGISTRO ${_obra.obrasDocumentos[_current].nroregistro}) sólo puede ser eliminada por el Usuario que la cargó (${_obra.obrasDocumentos[_current].generadoPor}). De ser necesario borrarla comuníquese con el administrador del Sistema.');

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message:
      //         'Esta foto (NROREGISTRO ${_obra.obrasDocumentos[_current].nroregistro}) sólo puede ser eliminada por el Usuario que la cargó (${_obra.obrasDocumentos[_current].generadoPor}). De ser necesario borrarla comuníquese con el administrador del Sistema.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    var response = await customYesNoQuestionDialog(context,
        content: '¿Estas seguro de querer borrar esta foto?');

    // await showAlertDialog(
    //     context: context,
    //     title: 'Confirmación',
    //     message: '¿Estas seguro de querer borrar esta foto?',
    //     actions: <AlertDialogAction>[
    //       const AlertDialogAction(key: 'no', label: 'No'),
    //       const AlertDialogAction(key: 'yes', label: 'Sí'),
    //     ]);

    if (response == 'yes') {
      await _deletePhoto();
    }
  }

//------------------------------ _deletePhoto --------------------------
  Future<void> _deletePhoto() async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});

      await customErrorDialog(
          context, 'Error', 'Verifica que estés conectado a Internet');

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Verifica que estes conectado a internet.',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    Response response = await ApiHelper.delete('/api/ObrasDocuments/',
        _obra.obrasDocumentos[_current].nroregistro.toString());

    setState(() {});

    if (!response.isSuccess) {
      await customErrorDialog(context, 'Error', 'response.message');

      // await showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: response.message,
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      return;
    }

    setState(() {
      _getObra();
    });
  }

//------------------------------ _getObra --------------------------

  Future<void> _getObra() async {
    _obrasDocumentos = [];
    _obrasDocumentosFotos = [];

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});

      await customErrorDialog(
          context, 'Error', 'Verifica que estés conectado a Internet');

      return;
    }

    Response response = await ApiHelper.getObra(_obra.nroObra.toString());

    if (!response.isSuccess) {
      await customErrorDialog(context, 'Error', 'N° de Obra no válido');

      setState(() {});
      return;
    }
    _obra = response.result;
    _obrasDocumentos = _obra.obrasDocumentos.toList();

    for (ObrasDocumento obraDocumento in _obrasDocumentos) {
      if (obraDocumento.tipoDeFoto == 3) {
        obraDocumento.tipoDeFoto = 4;
      }
      if (obraDocumento.tipoDeFoto == 10) {
        obraDocumento.tipoDeFoto = 3;
      }
      if (obraDocumento.tipoDeFoto! < 20) {
        _obrasDocumentosFotos.add(obraDocumento);
      }
    }

    _obrasDocumentosFotos.sort((a, b) {
      return a.tipoDeFoto
          .toString()
          .toLowerCase()
          .compareTo(b.tipoDeFoto.toString().toLowerCase());
    });
    _current = 0;

    setState(() {
      if (_obrasDocumentosFotos.isNotEmpty) {
        //_carouselController.jumpToPage(0);
      }
    });
  }

//-------------------- _showSnackbar --------------------------
  void _showSnackbar(String text) {
    SnackBar snackbar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.lightGreen,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
