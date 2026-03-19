import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HeatmapImageGenerator {
  static final GlobalKey repaintKey = GlobalKey();

  static Future<Uint8List?> capture() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final boundary = repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 300));
        return capture();
      }

      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData =
      await image.toByteData(format: ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Capture error: $e");
      return null;
    }
  }
}