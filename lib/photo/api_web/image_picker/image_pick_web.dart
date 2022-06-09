import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<PlatformFile?> filePickFromDeviceWeb() async {
  try {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
      ],
    );
    if (file == null) return null;
    return file.files.first;
  } on PlatformException catch (e) {
    debugPrint('No Image found. Error: $e');
    return null;
  }
}
