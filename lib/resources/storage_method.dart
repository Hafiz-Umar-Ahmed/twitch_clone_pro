import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

import 'package:twitch_clone_pro/utils/utils.dart';

class StorageMethod {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> uploadtoStorage(
    BuildContext context,
    String bucketName,
    Uint8List image,
    String uid,
  ) async {
    try {
      final response = await _client.storage
          .from(bucketName)
          .uploadBinary(
            'thumbnails/$uid',
            image,
            fileOptions: const FileOptions(
              contentType: 'image/png', // or 'image/jpeg'
            ),
          );

      if (response.isNotEmpty) {
        final publicUrl = _client.storage
            .from(bucketName)
            .getPublicUrl('thumbnails/$uid');
        return publicUrl;
      } else {
        return null;
      }
    } catch (e) {
      showSnackBar(context, 'Failed to upload image: ${e.toString()}');
    }
    return null;
  }

  Future<bool> checkUrlExist(String bucketName, String uid) async {
    bool exists = false;
    final files = await _client.storage
        .from(bucketName) // replace with your bucket name
        .list(path: 'thumbnails/');
    if (files.isNotEmpty) {
      print('first func:${files[0].name}');
      exists = files.any((file) => file.name == uid);
    }
    return exists;
  }

  Future<void> deleteFile(String bucketName, String uid) async {
    final response = await _client.storage.from(bucketName).remove([
      'thumbnails/$uid',
    ]);
  }
}
