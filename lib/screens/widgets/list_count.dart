import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';

Widget listCount(String title, int count) {
  return Container(
    padding: const EdgeInsets.all(10),
    height: 40,
    child: Row(
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            )),
        Text(count.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            )),
      ],
    ),
  );
}
