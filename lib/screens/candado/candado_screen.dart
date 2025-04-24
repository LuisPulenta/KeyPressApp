import 'package:flutter/material.dart';

import '../../widgets/confirm_dialog.dart';
import '../inicio/company_screen.dart';

class CandadoScreen extends StatefulWidget {
  const CandadoScreen({Key? key}) : super(key: key);

  @override
  State<CandadoScreen> createState() => _CandadoScreenState();
}

class _CandadoScreenState extends State<CandadoScreen> {
  String numero1 = '0';
  String numero2 = '0';
  String numero3 = '0';
  String numero4 = '0';

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        fontSize: 32.0,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 250,
                  height: 180,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  //color: Colors.yellow,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          onSelectedItemChanged: (value) {
                            numero1 = value.toString();
                            setState(() {});
                          },
                          itemExtent: 42,
                          diameterRatio: .9,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List<Widget>.generate(
                              10,
                              (index) => Text('$index', style: style),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          onSelectedItemChanged: (value) {
                            numero2 = value.toString();
                            setState(() {});
                          },
                          itemExtent: 42,
                          diameterRatio: 0.9,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List<Widget>.generate(
                              10,
                              (index) => Text('$index', style: style),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          onSelectedItemChanged: (value) {
                            numero3 = value.toString();
                            setState(() {});
                          },
                          itemExtent: 42,
                          diameterRatio: 0.9,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List<Widget>.generate(
                              10,
                              (index) => Text('$index', style: style),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          onSelectedItemChanged: (value) {
                            numero4 = value.toString();
                            setState(() {});
                          },
                          itemExtent: 42,
                          diameterRatio: 0.9,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List<Widget>.generate(
                              10,
                              (index) => Text('$index', style: style),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 70,
                  child: Container(
                    width: 250,
                    height: 40,
                    color: const Color.fromARGB(46, 86, 180, 227),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            // Text(numero1 + numero2 + numero3 + numero4,
            //     style: const TextStyle(
            //         color: Colors.black,
            //         fontSize: 28,
            //         fontWeight: FontWeight.bold)),

            numero1 + numero2 + numero3 + numero4 != '2306'
                ? const SizedBox(
                    width: 200,
                    height: 200,
                    child: Icon(
                      Icons.lock,
                      color: Colors.red,
                      size: 150,
                    ),
                  )
                : Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: IconButton(
                        onPressed: () async {
                          bool result = await showConfirmDialog(context,
                              title: 'Atención!',
                              content: 'Está seguro de cambiar de empresa?');
                          if (result) {
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CompanyScreen(),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.lock_open,
                          color: Colors.green,
                          size: 150,
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
