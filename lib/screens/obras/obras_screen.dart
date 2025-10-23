import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keypressapp/providers/app_state_provider.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../config/theme/app_theme.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';
import '../widgets/list_count.dart';
import '../widgets/no_content.dart';

class ObrasScreen extends StatefulWidget {
  const ObrasScreen({super.key});

  @override
  _ObrasScreenState createState() => _ObrasScreenState();
}

class _ObrasScreenState extends State<ObrasScreen> {
  //----------------------- Variables -----------------------------
  List<Obra> _obras = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  Obra obraSelected = Obra(
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
    grupoCausante: '',
  );

  //----------------------- initState -----------------------------
  @override
  void initState() {
    super.initState();
    _getObras();
  }

  //----------------------- Pantalla -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Obras'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter,
                  icon: const Icon(Icons.filter_none),
                )
              : IconButton(
                  onPressed: _showFilter,
                  icon: const Icon(Icons.filter_alt),
                ),
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

  //------------------------------ _filter --------------------------
  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Obra> filteredList = [];
    for (var obra in _obras) {
      if (obra.nombreObra.toLowerCase().contains(_search.toLowerCase()) ||
          obra.elempep.toLowerCase().contains(_search.toLowerCase()) ||
          obra.modulo!.toLowerCase().contains(_search.toLowerCase()) ||
          obra.nroObra.toString().toLowerCase().contains(
            _search.toLowerCase(),
          )) {
        filteredList.add(obra);
      }
    }

    setState(() {
      _obras = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  //------------------------------ _removeFilter --------------------------
  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getObras();
  }

  //------------------------------ _showFilter --------------------------
  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Obras'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Nombre o N° de Obra o en OP/N° de Fuga o en Módulo: ',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _filter(),
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  //------------------------------ _getContent --------------------------
  Widget _getContent() {
    return Column(
      children: <Widget>[
        listCount('Cantidad de Obras: ', _obras.length),
        Expanded(
          child: _obras.isEmpty
              ? noContent(
                  _isFiltered,
                  'No hay Obras con ese criterio de búsqueda',
                  'No hay Obras registradas',
                )
              : _getListView(),
        ),
      ],
    );
  }

  //------------------------------ _getListView ---------------------------
  Widget _getListView() {
    var f = NumberFormat('#,###', 'es');
    return RefreshIndicator(
      onRefresh: _getObras,
      child: ListView(
        children: _obras.map((e) {
          return Card(
            color: e.finalizada == 0
                ? const Color.fromARGB(255, 203, 222, 241)
                : const Color.fromARGB(255, 240, 202, 151),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                obraSelected = e;
                _goInfoObra(e);
              },
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  e.finalizada == 1
                                      ? const Text(
                                          'FINALIZADA',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    children: [
                                      const Text(
                                        'N° Obra: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          f.format(e.nroObra).toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const Text(
                                        'Ult.Mov.: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: e.fechaUltimoMovimiento != null
                                            ? Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(
                                                    e.fechaUltimoMovimiento
                                                        .toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
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
                                      //   child: Text(e.modulo.toString(),
                                      //       style: const TextStyle(
                                      //         fontSize: 12,
                                      //       )),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Nombre: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.nombreObra,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'OP/N° Fuga: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.elempep,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 20),

                                      e.obrasDocumentos.isNotEmpty
                                          ? _IconInfo(
                                              icon: Icons.camera_alt,
                                              text: e.obrasDocumentos.length
                                                  .toString(),
                                            )
                                          : Container(),

                                      // const Text('Fotos: ',
                                      //     style: TextStyle(
                                      //       fontSize: 12,
                                      //       color: AppTheme.primary,
                                      //       fontWeight: FontWeight.bold,
                                      //     )),
                                      // Expanded(
                                      //   child: Text(
                                      //       e.obrasDocumentos.length.toString(),
                                      //       style: const TextStyle(
                                      //         fontSize: 12,
                                      //       )),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: e.fechaCierreElectrico != null
                                        ? 5
                                        : 0,
                                  ),
                                  e.fechaCierreElectrico != null
                                      ? Row(
                                          children: [
                                            const Text(
                                              'Fecha Cierre Eléctrico: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(
                                                    e.fechaCierreElectrico
                                                        .toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //----------------------- _getObras -----------------------------
  Future<void> _getObras() async {
    final appStateProvider = context.watch<AppStateProvider>();
    User user = appStateProvider.user;
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
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getObras(user.modulo);

    if (!response.isSuccess) {
      if (mounted) {
        await customErrorDialog(context, 'Error', response.message);

        return;
      }
    }

    if (mounted) {
      setState(() {
        _showLoader = false;
        _obras = response.result;
        _obras.sort((a, b) {
          return a.nombreObra.toString().toLowerCase().compareTo(
            b.nombreObra.toString().toLowerCase(),
          );
        });
      });
    }
  }

  //----------------------- _goInfoObra ---------------------------
  void _goInfoObra(Obra obra) async {
    final appStateProvider = context.watch<AppStateProvider>();
    User user = appStateProvider.user;
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObraInfoScreen(user: user, obra: obra),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      _getObras();
      setState(() {});
    }
  }
}

//-------------------------- _IconInfo ------------------------------------
class _IconInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconInfo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(icon, color: AppTheme.primary),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 15,
              height: 15,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
