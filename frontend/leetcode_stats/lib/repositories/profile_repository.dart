import '../services/profile_service.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();

  Future<List> getRecentSolved(String username) async{
    final data = await _service.fetchRecentSolved(username);
    final solved = data["recentSolved"];
    if(solved == null){
      return [];
    }
    return solved;
  }
  Future<Map<String, dynamic>> getProfile(String username) async{
    final data = await _service.fetchProfile(username);
    final profile = data["profile"];
    if(profile == null){
      return {};
    }
    return profile;
  }
  Future<Map<String, dynamic>> getDailyQuestion(String username) async{
    final data = await _service.fetchDailyQuestion(username);
    final ques = data["activeDailyCodingChallengeQuestion"] ?? {};
    if(ques == null){
      return {};
    }
    return ques;
  }
}

