import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/theme/app_theme.dart';

Widget listCount(String title, int count) {
  var f = NumberFormat('#,###', 'es');

  return Container(
    padding: const EdgeInsets.all(10),
    height: 40,
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          f.format(count).toString(),
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
