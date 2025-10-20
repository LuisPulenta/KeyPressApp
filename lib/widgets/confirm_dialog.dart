import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.lightBlueAccent.withOpacity(.5),
    barrierDismissible: false,
    builder: (context) => _DialogContent(
      title: title,
      content: content,
    ),
  );
  return result ?? false;
}

//------------------------------------------------------------------

class _DialogContent extends StatelessWidget {
  final String title;
  final String content;

  const _DialogContent({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(content),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Sí',
                style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                )),
          ),
        ],
      ),
    );
  }
}
