import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/user.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class FlotaMenuScreen extends StatelessWidget {
  final User user;

  const FlotaMenuScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flota Menú'), centerTitle: true),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Image.asset('assets/logo.png', height: 40, width: 500),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlotaKmPreventivoScreen(user: user),
                ),
              );
            },
            child: SizedBox(
              width: ancho,
              child: const Boton(
                icon: FontAwesomeIcons.carBurst, //Icons.taxi_alert
                texto: 'Km. y Preventivos',
                color1: Color(0xff6989F5),
                color2: Color.fromARGB(200, 104, 101, 101),
              ),
            ),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlotaCheckListScreen(user: user),
                ),
              );
            },
            child: SizedBox(
              width: ancho,
              child: const Boton(
                icon: FontAwesomeIcons.listCheck,
                texto: 'Check List',
                color1: Color(0xff906EF5),
                color2: Color.fromARGB(199, 216, 213, 213),
              ),
            ),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlotaTurnosTallerScreen(user: user),
                ),
              );
            },
            child: SizedBox(
              width: ancho,
              child: const Boton(
                icon: FontAwesomeIcons.wrench,
                texto: 'Turnos Taller',
                color1: Color.fromARGB(200, 104, 101, 101),
                color2: Color(0xff6989F5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
