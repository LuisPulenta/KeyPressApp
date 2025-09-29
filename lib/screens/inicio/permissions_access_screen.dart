import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../utils/colors.dart';
import '../widgets/buttons/custom_outlined_button.dart';

class PermissionsAccessScreen extends StatelessWidget {
  const PermissionsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gpsProvider = Provider.of<PermissionsProvider>(context);

    return Scaffold(
      backgroundColor: fondo,
      body: Center(
        child: (gpsProvider.isGpsEnabled)
            ? const _AccessButton()
            : const _EnableGpsMessage(),
      ),
    );
  }
}

//------------------------------------------------------------------------
class _AccessButton extends StatelessWidget {
  const _AccessButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              FontAwesomeIcons.earthAmericas,
              color: Colors.red,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Debe habilitar los Permisos:',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(
          width: 100,
          child: Column(
            children: const [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Gps/Ubicación',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Cámara',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Teléfono',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        CustomOutlinedButton(
          isFilled: true,
          backGroundColor: primaryColor.withOpacity(0.3),
          text: 'Solicitar Permiso',
          onPressed: () {
            final gpsProvider =
                Provider.of<PermissionsProvider>(context, listen: false);
            gpsProvider.askPermissionsAccess();
          },
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
            width: 250,
            height: 250,
            child: SvgPicture.asset('assets/lost.svg')),
      ],
    );
  }
}

//------------------------------------------------------------------------
class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Debe habilitar la Ubicación',
            style: TextStyle(
                color: Colors.red, fontSize: 25, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 15,
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
            width: 250,
            height: 250,
            child: SvgPicture.asset('assets/confirm.svg')),
      ],
    );
  }
}
