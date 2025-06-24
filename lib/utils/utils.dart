import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String Content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Content)));
}

Future<Uint8List?> imagePicker() async {
  FilePickerResult? imagePicked = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  if (imagePicked != null) {
    if (kIsWeb) {
      return imagePicked.files.single.bytes;
    }
    return await File(imagePicked.files.single.path!).readAsBytes();
  }
  return null;
}
