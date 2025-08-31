import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

Future<String?> customQuestionDialog(
  BuildContext context, {
  required String content,
  required String title1,
  required String option1,
  required String title2,
  required String option2,
}) {
  Size sizeButton = const Size(80, 40);
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: const [
            Icon(Icons.question_mark_outlined, size: 40, color: Colors.red),
          ],
        ),
        content: SizedBox(height: 30, child: Center(child: Text(content))),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, option1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  minimumSize: sizeButton,
                ),
                child: Text(
                  title1,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, option2);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary.withOpacity(0.7),
                  minimumSize: sizeButton,
                ),
                child: Text(
                  title2,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'cancel');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: sizeButton,
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
