import 'package:flutter/material.dart';

import 'terminos_text.dart';

class TerminosScreen extends StatelessWidget {
  const TerminosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              const Text('Términos y Condiciones de uso',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: TerminosText.terms.length,
                    itemBuilder: (context, index) {
                      final item = TerminosText.terms[index];
                      if (index > 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontSize: 16),
                              children: [
                                TextSpan(
                                  text: '${item['title']}\n',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: item['content'],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${item['title']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              Text(
                                '${item['content']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF120E43),
                      minimumSize: const Size(150, 40),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.home),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Aceptar'),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




//  style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontStyle: FontStyle.normal,
//                                 color: Colors.black,
//                                 fontFamily: 'PTSansNarrow-Regular',
//                                 fontSize: 16,
//                               )