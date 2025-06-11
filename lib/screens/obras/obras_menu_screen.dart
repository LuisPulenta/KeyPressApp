import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/user.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class ObrasMenuScreen extends StatelessWidget {
  final User user;

  const ObrasMenuScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obras Menú'),
        centerTitle: true,
      ),
      body: _getBody(context),
    );
  }

  //----------------------- _getBody ------------------------------
  Widget _getBody(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Image.asset(
                  'assets/logo.png',
                  height: 40,
                  width: 500,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ObrasScreen(
                    user: user,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: ancho,
              child: const Boton(
                icon: FontAwesomeIcons.personDigging,
                texto: 'Gestión de Obras',
                color1: Color.fromARGB(255, 51, 7, 7),
                color2: Color.fromARGB(255, 85, 51, 67),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ObrasRelevamientosScreen(
                    user: user,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: ancho,
              child: const Boton(
                icon: FontAwesomeIcons.mapPin,
                texto: 'Relevamientos',
                color1: Color.fromARGB(255, 91, 19, 19),
                color2: Color.fromARGB(255, 149, 93, 119),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
