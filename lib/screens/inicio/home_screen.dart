import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/models.dart';
import '../../themes/app_theme.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//----------------------- Variables -----------------------------
  String direccion = '';

//----------------------- initState -----------------------------
  @override
  void initState() {
    super.initState();
  }

//----------------------- Pantalla ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Keypress App'),
      //   centerTitle: true,
      // ),
      body: _getBody(),
    );
  }

//----------------------- _getBody ------------------------------
  Widget _getBody() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 5),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ],
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
                  child: Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: AppTheme.primary,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
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
                            color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        "${widget.user.nombre!.replaceAll("  ", "")} ${widget.user.apellido!.replaceAll("  ", "")}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ObrasScreen(
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: const Boton(
                      icon: FontAwesomeIcons.personDigging,
                      texto: 'Obras',
                      color1: Color.fromARGB(255, 51, 7, 7),
                      color2: Color.fromARGB(255, 85, 51, 67),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsuariosScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: const Boton(
                      icon: FontAwesomeIcons.users,
                      texto: 'Usuarios',
                      color1: Color.fromARGB(255, 226, 105, 245),
                      color2: Color.fromARGB(255, 228, 177, 201),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EppScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: const Boton(
                      icon: FontAwesomeIcons.helmetSafety,
                      texto: 'EPP',
                      color1: Color.fromARGB(255, 247, 88, 20),
                      color2: Color.fromARGB(255, 215, 192, 179),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlotaScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: const Boton(
                      icon: FontAwesomeIcons.car,
                      texto: 'Flota',
                      color1: Color(0xff6989F5),
                      color2: Color(0xff906EF5),
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
        ));
  }

//----------------------- _logOut -------------------------------
  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userBody', '');
    await prefs.setString('empresaBody', '').then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
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
