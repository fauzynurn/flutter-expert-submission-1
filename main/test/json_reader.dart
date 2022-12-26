import 'package:flutter/services.dart';

Future<String> readJson(String path) async {
  return await rootBundle.loadString(path);
}
