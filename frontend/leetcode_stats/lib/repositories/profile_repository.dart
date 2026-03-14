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
}