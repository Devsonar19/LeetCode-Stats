import 'package:shared_preferences/shared_preferences.dart';

class WidgetSyncService {
  static Future<void> updateWidgetData({
    required int maxStreak,
    required int todaySubmissions,
  }) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt("maxStreak", maxStreak);
    await pref.setInt("todaySubmissions", todaySubmissions);
  }
}