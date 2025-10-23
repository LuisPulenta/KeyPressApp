import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keypressapp/config/router/app_router.dart';
import 'package:keypressapp/models/models.dart';
import 'package:keypressapp/providers/app_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/theme/app_theme.dart';
import '../../helpers/api_helper.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //----------------------- Variables -----------------------------
  String direccion = '';
  int? _nroConexion = 0;
  User? user;
  Empresa? empresa;

  //----------------------- Pantalla ------------------------------
  @override
  Widget build(BuildContext context) {
    final appStateProvider = context.watch<AppStateProvider>();
    user = appStateProvider.user;
    empresa = appStateProvider.empresa;
    return Scaffold(
      appBar: AppBar(centerTitle: true),
      drawer: _getMenu(),
      body: _getBody(),
    );
  }

  //----------------------- _getBody ------------------------------
  Widget _getBody() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset('assets/logo.png', height: 100, width: 500),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(color: AppTheme.primary, thickness: 2),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Bienvenido/a',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      "${user!.nombre!.replaceAll("  ", "")} ${user!.apellido!.replaceAll("  ", "")}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              //--------------- Obras ---------------
              InkWell(
                onTap: empresa!.habilitaObras == 1
                    ? () {
                        appRouter.push('/obrasmenu');
                      }
                    : null,
                child: SizedBox(
                  width: ancho * 0.5,
                  child: Boton(
                    icon: FontAwesomeIcons.personDigging,
                    texto: 'Obras',
                    color1: empresa!.habilitaObras == 1
                        ? const Color.fromARGB(255, 51, 7, 7)
                        : const Color.fromARGB(200, 104, 101, 101),
                    color2: empresa!.habilitaObras == 1
                        ? const Color.fromARGB(255, 85, 51, 67)
                        : const Color.fromARGB(199, 216, 213, 213),
                  ),
                ),
              ),
              //--------------- Compras ---------------
              InkWell(
                onTap:
                    empresa!.habilitaCompras == 1 &&
                        user!.estadoInv == true &&
                        user!.compras == true
                    ? () {
                        appRouter.push('/compras');
                      }
                    : null,
                child: SizedBox(
                  width: ancho * 0.5,
                  child: Boton(
                    icon: FontAwesomeIcons.cartShopping,
                    texto: 'Compras',
                    color1:
                        empresa!.habilitaCompras == 1 &&
                            user!.estadoInv == true &&
                            user!.compras == true
                        ? const Color.fromARGB(255, 226, 105, 245)
                        : const Color.fromARGB(200, 104, 101, 101),
                    color2:
                        empresa!.habilitaCompras == 1 &&
                            user!.estadoInv == true &&
                            user!.compras == true
                        ? const Color.fromARGB(255, 228, 177, 201)
                        : const Color.fromARGB(199, 216, 213, 213),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              //--------------- Instalaciones ---------------
              InkWell(
                onTap: empresa!.habilitaInstalaciones == 1
                    ? () {
                        appRouter.push('/instalaciones');
                      }
                    : null,
                child: SizedBox(
                  width: ancho * 0.5,
                  child: Boton(
                    icon: FontAwesomeIcons.towerBroadcast,
                    texto: 'Instalaciones',
                    color1: empresa!.habilitaInstalaciones == 1
                        ? const Color.fromARGB(255, 8, 115, 44)
                        : const Color.fromARGB(200, 104, 101, 101),
                    color2: empresa!.habilitaInstalaciones == 1
                        ? const Color.fromARGB(255, 112, 227, 74)
                        : const Color.fromARGB(199, 216, 213, 213),
                  ),
                ),
              ),
              //--------------- FLota ---------------
              InkWell(
                onTap: empresa!.habilitaFlotas == 1
                    ? () {
                        appRouter.push('/flota');
                      }
                    : null,
                child: SizedBox(
                  width: ancho * 0.5,
                  child: Boton(
                    icon: FontAwesomeIcons.car,
                    texto: 'Flota',
                    color1: empresa!.habilitaFlotas == 1
                        ? const Color(0xff6989F5)
                        : const Color.fromARGB(200, 104, 101, 101),
                    color2: empresa!.habilitaFlotas == 1
                        ? const Color(0xff906EF5)
                        : const Color.fromARGB(199, 216, 213, 213),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              //--------------- RRHH ---------------
              InkWell(
                onTap: empresa!.habilitaRRHH == 1
                    ? () {
                        appRouter.push('/rrhh');
                      }
                    : null,
                child: SizedBox(
                  width: ancho * 0.5,
                  child: Boton(
                    icon: FontAwesomeIcons.peopleArrows,
                    texto: 'RR.HH.',
                    color1: empresa!.habilitaRRHH == 1
                        ? const Color.fromARGB(255, 9, 238, 185)
                        : const Color.fromARGB(200, 104, 101, 101),
                    color2: empresa!.habilitaRRHH == 1
                        ? const Color.fromARGB(255, 141, 231, 192)
                        : const Color.fromARGB(199, 216, 213, 213),
                  ),
                ),
              ),
              //--------------- FLota ---------------
              InkWell(
                onTap: empresa!.habilitaReciboSueldos == 1
                    ? () {
                        appRouter.push('/recibossueldo');
                      }
                    : null,
                child: SizedBox(
                  width: ancho * 0.5,
                  child: Boton(
                    icon: FontAwesomeIcons.fileInvoiceDollar,
                    texto: 'Recibos Sueldo',
                    color1: empresa!.habilitaReciboSueldos == 1
                        ? const Color.fromARGB(255, 228, 101, 10)
                        : const Color.fromARGB(200, 104, 101, 101),
                    color2: empresa!.habilitaReciboSueldos == 1
                        ? const Color.fromARGB(255, 221, 159, 101)
                        : const Color.fromARGB(199, 216, 213, 213),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  _logOut();
                },
                child: SizedBox(
                  width: ancho * 1,
                  child: const Boton(
                    icon: FontAwesomeIcons.doorOpen,
                    texto: 'Cerrar Sesión',
                    color1: Color.fromARGB(255, 236, 8, 8),
                    color2: Color.fromARGB(255, 211, 116, 113),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //----------------------- _logOut -------------------------------
  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //------------ Guarda en WebSesion la fecha y hora de salida ----------
    _nroConexion = prefs.getInt('nroConexion');
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      await ApiHelper.putWebSesion(_nroConexion!);
    }

    await prefs.setString('userBody', '');
    await prefs.setString('empresa!.Body', '').then((_) {
      appRouter.pushReplacement('/login');
    });
  }

  //----------------------- _getMenu -------------------------------
  Widget _getMenu() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff004f95), Color(0xff004f95)],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Image(image: AssetImage('assets/logo.png'), width: 200),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const Text(
                        'Usuario: ',
                        style: (TextStyle(
                          color: Color(0xff004f95),
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      Text(
                        '${user!.nombre} ${user!.apellido}',
                        style: (const TextStyle(color: AppTheme.primary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white, height: 1),
            Row(
              children: [
                Expanded(
                  child: ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Acerca de',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 15.0),
                          dense: true,
                          leading: const Icon(
                            FontAwesomeIcons.fileContract,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text(
                            'Términos y Condiciones',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onTap: () {
                            appRouter.push('/terminos');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 15.0),
                          dense: true,
                          leading: const Icon(
                            Icons.do_not_disturb_alt_outlined,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text(
                            'Cómo cuidamos tu privacidad',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onTap: () {
                            appRouter.push('/privacidad');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 15.0),
                          dense: true,
                          leading: const Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text(
                            'Defensa del consumidor',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onTap: () async {
                            appRouter.push('/defensaconsumidor');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white, height: 1),
            ListTile(
              dense: true,
              leading: const Icon(Icons.notifications, color: Colors.white),
              tileColor: const Color(0xff8c8c94),
              title: const Text(
                'Notificaciones',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                appRouter.push('/notificaciones');
              },
            ),
            const Divider(color: Colors.white, height: 1),
            ListTile(
              dense: true,
              leading: const Icon(
                Icons.edit_notifications_outlined,
                color: Colors.white,
              ),
              tileColor: const Color(0xff8c8c94),
              title: const Text(
                'Enviar Notificación',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                appRouter.push('/enviarnotificacion');
              },
            ),
            const Divider(color: Colors.white, height: 1),

            ListTile(
              dense: true,
              leading: const Icon(Icons.logout, color: Colors.white),
              tileColor: const Color(0xff8c8c94),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

//----------------------- ItemBoton ---------------------------

class ItemBoton {
  final IconData icon;
  final String texto;
  final Color color1;
  final Color color2;

  ItemBoton(this.icon, this.texto, this.color1, this.color2);
}
