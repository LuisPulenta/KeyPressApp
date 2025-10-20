import 'package:flutter/material.dart';

Widget noContent(bool isFiltered, text1, text2) {
  return Container(
    margin: const EdgeInsets.all(20),
    child: Center(
      child: Text(
        isFiltered ? text1 : text2,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
