import 'package:flutter/material.dart';

Future<String?> customYesNoQuestionDialog(
  BuildContext context, {
  required String content,
}) {
  Size sizeButton = const Size(80, 40);
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: const [
            Icon(
              Icons.question_mark_outlined,
              size: 40,
              color: Colors.red,
            ),
          ],
        ),
        content: SizedBox(height: 30, child: Center(child: Text(content))),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    'yes',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: sizeButton,
                ),
                child: const Text(
                  'Sí',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'no');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: sizeButton,
                ),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
