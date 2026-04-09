import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leetcode_stats/core/caching/cache_service.dart';
import '../services/api_service.dart';
import '../services/profile_service.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();
  final CacheService _cacheService = CacheService();


  Future<List> getRecentSolved(String username) async{
    final data = await _service.fetchRecentSolved(username);
    final solved = data["recentSolved"];
    if(solved == null){
      return [];
    }
    return solved;
  }

  Future<Map<String, dynamic>> getProfile(String username, {bool forceRefresh = false}) async{
    debugPrint("checking cache");
    final cacheKey = "user_profile_$username";
    final badgeKey = "badges_$username";

    final cache = _cacheService.getCache(cacheKey);
    if(!forceRefresh && cache != null){
      debugPrint("Cache found");
      final timeStamp = cache["timestamp"];

      final isExpired = DateTime
          .now()
          .difference(DateTime.parse(timeStamp))
          .inMinutes > 5;

      if(!isExpired){
        debugPrint("Returning cached data");
        return jsonDecode(jsonEncode(cache["data"]));
      }else{
        debugPrint("Cache expired");
      }
    }

    final freshNewData = await ApiService.fetchProfileForApp(username);

    final user = freshNewData["profile"] ?? {};
    final badges = user["badges"] ?? [];

    await _cacheService.save(
      key: cacheKey,
      data: freshNewData,
    );

    await _cacheService.save(
        key: badgeKey,
        data: {
          "badges": badges,
        }
    );

    return freshNewData;
  }


  Future<Map<String, dynamic>> getDailyQuestion(String username) async{
    final data = await _service.fetchDailyQuestion(username);
    final ques = data["activeDailyCodingChallengeQuestion"] ?? {};
    if(ques == null){
      return {};
    }
    return ques;
  }

  List getCacheBadges(String username){
    final cache = _cacheService.getCache("badges_$username");
    if(cache == null){
      return [];
    }
    return cache["data"]["badges"] ?? [];
  }
}

