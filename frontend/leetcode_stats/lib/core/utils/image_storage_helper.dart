import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class ImageStorageHelper {
  static Future<String> save(Uint8List bytes) async{
    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/image.png');

    await file.writeAsBytes(bytes);
    return file.path;
  }
}