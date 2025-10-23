import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:keypressapp/providers/providers.dart';
import 'package:provider/provider.dart';

import '../../components/custom_error_dialog.dart';
import '../../components/loader_component.dart';
import '../../config/theme/app_theme.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/confirm_dialog.dart';
import '../widgets/list_count.dart';
import '../widgets/no_content.dart';

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  ComprasScreenState createState() => ComprasScreenState();
}

class ComprasScreenState extends State<ComprasScreen> {
  //----------------------- Variables -----------------------------
  List<PEPedido> _compras = [];
  List<PEPedido> _comprasByNroPedido = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  PEPedido compraSelected = PEPedido(
    nroPedido: 0,
    fecha: '',
    estado: '',
    nroPedidoObra: '',
    totalItemAprobados: 0,
    importeAprobados: 0.0,
    idusuario: 0,
    idfirma: 0,
  );

  //----------------------- initState -----------------------------
  @override
  void initState() {
    super.initState();
    _getCompras();
  }

  //----------------------- Pantalla -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Compras'),
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
    List<PEPedido> filteredList = [];
    for (var compra in _compras) {
      if (compra.nroPedidoObra.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(compra);
      }
    }

    setState(() {
      _compras = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  //------------------------------ _removeFilter --------------------------
  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getCompras();
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
                'Escriba texto o números a buscar en Nombre o N° de Pedido de Obra: ',
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
        listCount('Cantidad de Compras: ', _compras.length),
        Expanded(
          child: _compras.isEmpty
              ? noContent(
                  _isFiltered,
                  'No hay Compras con ese criterio de búsqueda',
                  'No hay Compras registradas',
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
      onRefresh: _getCompras,
      child: ListView(
        children: _compras.map((e) {
          return Card(
            color: const Color.fromARGB(255, 203, 222, 241),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                compraSelected = e;
                //_goInfoObra(e);
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
                                  Row(
                                    children: [
                                      const Text(
                                        'N° Pedido: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          f.format(e.nroPedido).toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const Text(
                                        'Fecha: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(e.fecha.toString()),
                                          ),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          'N° Pedido de Obra: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          e.nroPedidoObra,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Total Items Aprobados: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          e.totalItemAprobados.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Importe Aprob.: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          NumberFormat.currency(
                                            symbol: '\$',
                                          ).format(e.importeAprobados),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          bool result = await showConfirmDialog(
                            context,
                            title: 'Atención!',
                            content:
                                'Está seguro de firmar el Pedido N° ${e.nroPedido} de ${NumberFormat.currency(symbol: '\$').format(e.importeAprobados)}?',
                          );
                          if (result) {
                            _firmarPedido(e.idfirma, e.nroPedido);
                          }
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.signature,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //----------------------- _getCompras -----------------------------
  Future<void> _getCompras() async {
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

    response = await ApiHelper.getPEPedidos(user.idUsuario);

    if (!response.isSuccess) {
      if (mounted) {
        await customErrorDialog(context, 'Error', response.message);
        return;
      }
    }

    if (mounted) {
      setState(() {
        _showLoader = false;
        _compras = response.result;
        _compras.sort((a, b) {
          return a.nroPedido.toString().toLowerCase().compareTo(
            b.nroPedido.toString().toLowerCase(),
          );
        });
      });
    }
  }

  //----------------------- getPEPedidosByNroPedido -----------------------------
  Future<void> _getPEPedidosByNroPedido(int nroPedido) async {
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

    response = await ApiHelper.getPEPedidosByNroPedido(nroPedido);

    if (!response.isSuccess) {
      if (mounted) {
        await customErrorDialog(context, 'Error', response.message);
        return;
      }
    }

    if (mounted) {
      setState(() {
        _showLoader = false;
        _comprasByNroPedido = response.result;
        _comprasByNroPedido.sort((a, b) {
          return a.nroPedido.toString().toLowerCase().compareTo(
            b.nroPedido.toString().toLowerCase(),
          );
        });
      });
    }

    if (_comprasByNroPedido.isEmpty) {
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

      Map<String, dynamic> request = {'NroPedido': nroPedido};

      response = await ApiHelper.put(
        '/api/PEPedidos/PutPEPPedido/',
        nroPedido.toString(),
        request,
      );

      if (!response.isSuccess) {
        if (mounted) {
          await customErrorDialog(context, 'Error', response.message);
          setState(() {
            _showLoader = false;
          });
          return;
        }
      }
      setState(() {
        _showLoader = false;
      });
    }
  }

  //----------------------- _firmarPedido ---------------------------
  void _firmarPedido(int idfirma, int nroPedido) async {
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

    Map<String, dynamic> request = {'IDFIRMA': idfirma};

    response = await ApiHelper.put(
      '/api/PEPedidos/PutPedidosFirma/',
      idfirma.toString(),
      request,
    );

    if (!response.isSuccess) {
      if (mounted) {
        await customErrorDialog(context, 'Error', response.message);
        return;
      }
    }

    _getCompras();
    _getPEPedidosByNroPedido(nroPedido);
  }
}
