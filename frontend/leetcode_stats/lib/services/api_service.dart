import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrlForWeb = "http://127.0.0.1:8000";
  static const baseUrlForAndroid = "http://127.0.0.1:8000";
  // using 10.0.2.2 url for Android emulator


  static Future<Map<String, dynamic>> fetchProfileForApp(String username) async {
    final response = await http.get(
      Uri.parse("$baseUrlForAndroid/profile/$username"),
    );


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  static Future<Map<String, dynamic>> fetchProfileForWeb(String username) async {
    final response = await http.get(
      Uri.parse("$baseUrlForWeb/profile/$username"),
    );


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }
}