import 'dart:convert';

import 'package:hive/hive.dart';

class CacheService {
  Box get _box => Hive.box("cacheBox");

  Future<void> save({
    required String key,
    required Map<String, dynamic> data,
  })async{
    await _box.put(
        key,
        {
          "data": data,
          "timestamp": DateTime.now().toIso8601String(),
        }
    );
  }

  Map<String, dynamic>? getCache(String key){

    if(!Hive.isBoxOpen('cacheBox')){
      return null;
    }

    final rawData = _box.get(key);
    if(rawData == null){
      return null;
    }
    return jsonDecode(jsonEncode(rawData));
  }

  Future<void> clearCache(String key){
    return _box.delete(key);
  }

  bool isExpired(String timestamp, Duration maxTime){
    final savedTime = DateTime.parse(timestamp);
    return DateTime.now().difference(savedTime) > maxTime;
  }
}