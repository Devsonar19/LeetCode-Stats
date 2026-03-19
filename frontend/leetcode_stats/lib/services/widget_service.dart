import 'package:flutter/services.dart';

class WidgetService {
  static const MethodChannel _channel = MethodChannel('widget_channel');

  static Future<void> updateWidget(String path) async {
    try {
      await _channel.invokeMethod('updateWidget', {
        'imagePath': path,
      });
    } catch (e) {
      print("Widget update failed: $e");
    }
  }
}