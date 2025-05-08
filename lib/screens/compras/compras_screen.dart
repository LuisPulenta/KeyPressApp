import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../themes/app_theme.dart';
import '../widgets/list_count.dart';
import '../widgets/no_content.dart';

class ComprasScreen extends StatefulWidget {
  final User user;
  const ComprasScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ComprasScreenState createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
//----------------------- Variables -----------------------------
  List<PEPedido> _compras = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  PEPedido compraSelected = PEPedido(
      nroPedido: 0,
      fecha: '',
      estado: '',
      nroPedidoObra: '',
      totalItemAprobados: 0,
      importeAprobados: 0.0);

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
                  onPressed: _removeFilter, icon: const Icon(Icons.filter_none))
              : IconButton(
                  onPressed: _showFilter, icon: const Icon(Icons.filter_alt)),
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
  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<PEPedido> filteredList = [];
    for (var compra in _compras) {
      if (compra.nroPedidoObra.toLowerCase().contains(
            _search.toLowerCase(),
          )) {
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
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Nombre o N° de Pedido de Obra: ',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Criterio de búsqueda...',
                    labelText: 'Buscar',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => _filter(), child: const Text('Filtrar')),
            ],
          );
        });
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
                  'No hay Compras registradas')
              : _getListView(),
        )
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
                                      const Text('N° Pedido: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            f.format(e.nroPedido).toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                      const Text('Fecha: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: e.fecha != null
                                            ? Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(
                                                        e.fecha.toString())),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ))
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text('N° Pedido de Obra: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.nroPedidoObra,
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
                                      const Text('Total Items Aprobados: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(
                                            e.totalItemAprobados.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text('Importe Aprobados: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child:
                                            Text(e.importeAprobados.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                )),
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

//----------------------- _getCompras -----------------------------
  Future<void> _getCompras() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getPEPedidos();

    if (!response.isSuccess) {
      if (mounted) {
        showMyDialog('Error', response.message, 'Aceptar');
        return;
      }
    }

    if (mounted) {
      setState(() {
        _showLoader = false;
        _compras = response.result;
        _compras.sort((a, b) {
          return a.nroPedido
              .toString()
              .toLowerCase()
              .compareTo(b.nroPedido.toString().toLowerCase());
        });
      });
    }
  }

//----------------------- _goInfoObra ---------------------------
  // void _goInfoObra(Obra obra) async {
  //   String? result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ObraInfoScreen(
  //         user: widget.user,
  //         obra: obra,
  //       ),
  //     ),
  //   );
  //   if (result == 'yes' || result != 'yes') {
  //     _getObras();
  //     setState(() {});
  //   }
  // }
}
