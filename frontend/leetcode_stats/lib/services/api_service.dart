import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrlForWeb = "https://leetcode-stats-backend-txi3.onrender.com";
  static const baseUrlForAndroid = "https://leetcode-stats-backend-txi3.onrender.com";
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
    const corsProxy = "https://corsproxy.io/?";
    final targetUrl = "$baseUrlForWeb/profile/$username";

    final response = await http.get(
      Uri.parse("$corsProxy${Uri.encodeComponent(targetUrl)}"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  static Future<Map<String, dynamic>> checkUser(String username) async{
    final data = await fetchProfileForApp(username);
    final profile = data["profile"];
    if(profile == null){
      throw Exception("User not Found");
    }
    return profile;

  }
}