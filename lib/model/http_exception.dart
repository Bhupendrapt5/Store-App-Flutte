import 'package:flutter/foundation.dart';

class HttpException implements Exception {
  final String messge;

  HttpException({@required this.messge});

  @override
  String toString() {
    return messge;
  }
}
