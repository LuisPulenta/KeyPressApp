import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../themes/app_theme.dart';
import '../screens.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  //----------------------- Variables -----------------------------

  bool _showLoader = false;
  List<Empresa> _empresas = [];

  List<ApiToSelect> apisToSelect = [];

//----------------------- initState -----------------------------
  @override
  void initState() {
    super.initState();
    _getEmpresas();
  }

//----------------------- Pantalla -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de Empresa'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: apisToSelect.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 50),
                                backgroundColor: index % 2 != 0
                                    ? AppTheme.primary
                                    : AppTheme.primary.withOpacity(0.5)),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  'company', apisToSelect[index].company);
                              await prefs.setString(
                                  'connection', apisToSelect[index].connection);
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoadingScreen(),
                                ),
                              );
                            },
                            child: Text(
                              apisToSelect[index].company,
                            )),
                      ),

                      // ListTile(
                      //   onTap: () async {
                      //     SharedPreferences prefs =
                      //         await SharedPreferences.getInstance();
                      //     await prefs.setString(
                      //         'company', apisToSelect[index].company);
                      //     await prefs.setString(
                      //         'connection', apisToSelect[index].connection);
                      //     await Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const LoginScreen(),
                      //       ),
                      //     );
                      //   },
                      //   title: Text(
                      //     apisToSelect[index].company,
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

//----------------------- _getEmpresas -----------------------------
  Future<void> _getEmpresas() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await customErrorDialog(
          context, 'Error', 'Verifica que estés conectado a Internet');
      return;

      // showAlertDialog(
      //     context: context,
      //     title: 'Error',
      //     message: 'Verifica que estés conectado a Internet',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getEmpresas();

    if (!response.isSuccess) {
      customErrorDialog(context, 'Error', response.message);

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
      _empresas = response.result;
      _empresas.sort((a, b) {
        return a.nombreEmpresa
            .toString()
            .toLowerCase()
            .compareTo(b.nombreEmpresa.toString().toLowerCase());
      });
    });

    for (var empresa in _empresas) {
      if (empresa.habilitaEmpresa == 1) {
        ApiToSelect apiToSelect = ApiToSelect(
            company: empresa.nombreEmpresa, connection: empresa.linkApi);
        apisToSelect.add(apiToSelect);
      }
    }

    setState(() {
      _showLoader = false;
    });
  }
}

//----------------------------------------------------------------
class ApiToSelect {
  String company;
  String connection;

  ApiToSelect({required this.company, required this.connection});
}
