import 'package:flutter/material.dart';
import 'package:keypressapp/screens/inicio/login_screen.dart';
import 'package:keypressapp/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  //----------------------- Variables -----------------------------
  List<ApiToSelect> apisToSelect = [
    ApiToSelect(
        company: "Rowing",
        connection: "https://keypress.serveftp.net/KPRowingApi"),
    ApiToSelect(
        company: "Fleet",
        connection: "https://keypress.serveftp.net/KPFleetApi"),
    ApiToSelect(
        company: "TYC", connection: "https://keypress.serveftp.net/KPTycApi"),
    ApiToSelect(
        company: "Ayko", connection: "https://keypress.serveftp.net/KPAykoApi"),
  ];

//----------------------- Pantalla -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de Empresa'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: apisToSelect.length,
                itemBuilder: (_, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          backgroundColor: index % 2 != 0
                              ? AppTheme.primary
                              : AppTheme.primary.withOpacity(.5)),
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
                            builder: (context) => const LoginScreen(),
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
}

//----------------------------------------------------------------
class ApiToSelect {
  String company;
  String connection;

  ApiToSelect({required this.company, required this.connection});
}
