import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static late String baseUrl;

  static Future<void> loadConfig() async {
    try {
      final String response = await rootBundle.loadString('assets/config.json');
      final Map<String, dynamic> config = json.decode(response);
      baseUrl = config['baseUrl'] ?? 'http://192.168.1.23/';
    } catch (e) {
      baseUrl = 'http://192.168.1.23/'; // Fallback URL
    }
  }
}