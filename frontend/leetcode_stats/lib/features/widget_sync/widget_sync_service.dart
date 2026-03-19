import 'package:flutter/services.dart';

class WidgetSyncService {
  static const MethodChannel _channel =
  MethodChannel('widget_channel');

  static Future<void> updateStreak({
    required int maxStreak,
    required int todaySubmissions,
  }) async {
    try {
      await _channel.invokeMethod('updateStreakWidget', {
        'maxStreak': maxStreak,
        'todaySubmissions': todaySubmissions,
      });

      print("STREAK SENT: $maxStreak, $todaySubmissions");
    } catch (e) {
      print("Streak update failed: $e");
    }
  }
}