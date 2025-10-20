import 'package:flutter/material.dart';
import 'package:keypressapp/utils/colors.dart';

class CustomRow extends StatelessWidget {
  IconData? icon;
  final String nombredato;
  final String? dato;
  bool? alert;

  CustomRow({
    super.key,
    this.icon,
    required this.nombredato,
    required this.dato,
    this.alert,
  });

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          icon != null
              ? alert == true
                    ? const Icon(Icons.warning, color: Colors.red)
                    : Icon(icon, color: primaryColor)
              : Container(),
          const SizedBox(width: 15),
          SizedBox(
            width: ancho * 0.3,
            child: Text(
              nombredato,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              dato != null ? dato.toString() : '',
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
