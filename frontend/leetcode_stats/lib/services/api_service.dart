import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrlForLinux = "http://localhost:8000";
  static const baseUrlForAndriod = "http://127.0.0.1:8000";
  // using 10.0.2.2 url for Android emulator


  static Future<Map<String, dynamic>> fetchProfile(String username) async {
    final response = await http.get(
      Uri.parse("$baseUrlForAndriod/profile/$username"),
    );

    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }
}