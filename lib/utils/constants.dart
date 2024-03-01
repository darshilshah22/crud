import 'package:flutter/material.dart';

TextStyle headingStyle =
    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600);

showSnackbar(BuildContext context, String content, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: isError ? Colors.red : Colors.green,
    ),
  );
}
