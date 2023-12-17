import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void handleResponse({
  required Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.data)['message']);
      break;
    case 500:
      showSnackBar(context, 'Internal server error');
      break;
    default:
      showSnackBar(context, 'Something went wrong');
  }
}
