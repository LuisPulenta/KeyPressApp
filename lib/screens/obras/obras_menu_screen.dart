import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keypressapp/config/router/app_router.dart';
import 'package:keypressapp/providers/providers.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../widgets/widgets.dart';

class ObrasMenuScreen extends StatelessWidget {
  const ObrasMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Obras Menú'), centerTitle: true),
      body: _getBody(context),
    );
  }

  //----------------------- _getBody ------------------------------
  Widget _getBody(BuildContext context) {
    final appStateProvider = context.watch<AppStateProvider>();
    User user = appStateProvider.user;
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
            onTap: () {
              appRouter.push('/obrasmenu');
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
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              appRouter.push('/obrasrelevamientos');
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
