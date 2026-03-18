import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetSyncService {
  static const platform = MethodChannel('widget_update');
  static Future<void> updateWidgetData({
    required int maxStreak,
    required int todaySubmissions,
  }) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt("max_streak", maxStreak);
    await pref.setInt("today_submissions", todaySubmissions);

    try{
      await platform.invokeMethod('updateWidget');
    } catch(e){
      print("Widget failed: $e");
    }
  }
}