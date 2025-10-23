import 'package:flutter/material.dart';

import '../../config/theme/app_theme.dart';

class UsersExample extends StatelessWidget {
  const UsersExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios de Ejemplo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _company(nameCompany: 'ROWING'),
            _userName(user: 'KEYPRESS', password: 'KEYROOT'),
            _userName(user: 'GPRIETO', password: 'CELESTE'),
            _userName(user: 'FSOSA', password: 'GDOPUTO'),
            _userName(user: 'SBENITEZ', password: 'GIMNASIA11'),
            _userName(user: 'JCASTRO', password: 'FRANJC'),
            SizedBox(height: 20),
            _company(nameCompany: 'FLEET'),
            _userName(user: 'KEYPRESS', password: 'KEYROOT'),
            _userName(user: 'SANTIAGO', password: 'SANTI1234'),
            _userName(user: 'EGRASSO', password: '505060'),
            _userName(user: 'GVILLALBA', password: '101010'),
            _userName(user: 'ASUNDBLAD', password: '70756'),
            SizedBox(height: 20),
            _company(nameCompany: 'TYC'),
            _userName(user: 'KEYPRESS', password: 'KEYROOT'),
            _userName(user: 'NOUCHE', password: 'MN2023'),
            _userName(user: 'VIRLIN', password: 'VL2023'),
            _userName(user: 'DIEGOM', password: 'DM2023'),
            _userName(user: 'OSVBAL', password: 'BAL001'),
            SizedBox(height: 20),
            _company(nameCompany: 'AYKO'),
            _userName(user: 'KEYPRESS', password: 'KEYROOT'),
            _userName(user: 'SWOLANSKI', password: 'SAN2016'),
            _userName(user: 'ELUSENHOFF', password: 'EZE2016'),
            _userName(user: 'ALEJANDRA', password: 'ALE2016'),
            _userName(user: 'JPEREIRA', password: 'JPEREIRA'),
          ],
        ),
      ),
    );
  }
}

class _userName extends StatelessWidget {
  final String user;
  final String password;
  const _userName({required this.user, required this.password});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(user, style: const TextStyle(fontSize: 12))),
        Expanded(child: Text(password, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}

class _company extends StatelessWidget {
  final String nameCompany;
  const _company({required this.nameCompany});

  @override
  Widget build(BuildContext context) {
    return Text(
      nameCompany,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: AppTheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
