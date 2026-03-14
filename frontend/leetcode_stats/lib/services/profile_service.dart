import 'api_service.dart';

class ProfileService {
  Future<Map<String, dynamic>> fetchRecentSolved(String username) async {
    final response = await ApiService.fetchProfileForApp(username);
    return response;
  }
}