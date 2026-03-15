import 'api_service.dart';

class ProfileService {
  Future<Map<String, dynamic>> fetchRecentSolved(String username) async {
    final response = await ApiService.fetchProfileForApp(username);
    return response;
  }
  Future<Map<String, dynamic>> fetchProfile(String username) async {
    final response = await ApiService.fetchProfileForApp(username);
    return response;
  }

  Future<Map<String, dynamic>> fetchDailyQuestion(String username) async {
    final response = await ApiService.fetchProfileForApp(username);
    return response;
  }
}

