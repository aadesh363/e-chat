import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageSaver {
  static Future<File> saveImagePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();

    final name = path.split('/').last;

    final image = File('${directory.path}/$name');

    return File(path).copy(image.path);
  }
}