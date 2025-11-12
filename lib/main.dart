import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.lichi.com/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
    ),
  );

  runApp(App(dio: dio));
}
