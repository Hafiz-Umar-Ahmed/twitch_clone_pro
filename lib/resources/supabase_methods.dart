import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitch_clone_pro/model/comment.dart';
import 'package:twitch_clone_pro/model/livestream.dart';
import 'package:twitch_clone_pro/provider/user_provider.dart';
import 'package:twitch_clone_pro/resources/storage_method.dart';
import 'package:twitch_clone_pro/utils/utils.dart';

class SupabaseMethods {
  final SupabaseClient _client = Supabase.instance.client;

  final StorageMethod _storageMethod = StorageMethod();
  final String databaseName = 'livestreams';
  final String bucketName = 'livestream-thumbnails';
  SupabaseClient get client => _client;
  Future<String> startLiveStream(
    BuildContext context,
    Uint8List? image,
    String title,
  ) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String channelId = '';
    try {
      if (title.isNotEmpty && image != null) {
        if (!(await _storageMethod.checkUrlExist(bucketName, user.user.uid))) {
          String? url = await _storageMethod.uploadtoStorage(
            context,
            bucketName,
            image,
            user.user.uid,
          );
          if (url == null) {
            showSnackBar(context, 'Failed to upload image.');
            return '';
          }
          channelId = '${user.user.uid}${user.user.username}';
          LiveStream liveStream = LiveStream(
            title: title,
            image: url,
            uid: user.user.uid,
            username: user.user.username,
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          );
          final response = await _client
              .from(databaseName)
              .insert(liveStream.toMap());
          if (response != null) {
            channelId = '';
            showSnackBar(
              context,
              'livestream not started due to some database error.',
            );
          }
        } else {
          showSnackBar(
            context,
            'Two Livestreams cannot start at the same time.',
          );
          channelId = '';
        }
      }
    } catch (e) {
      print('Error starting livestream: ${e.toString()}');
      showSnackBar(context, 'An error occurred: $e.message');
      channelId = '';
    }
    return channelId;
  }

  Future<void> endLiveStream(String channelId, String uid) async {
    try {
      await _client.from(databaseName).delete().eq('channelId', channelId);
      await _client.from('comments').delete().eq('channelId', channelId);
      await _storageMethod.deleteFile(bucketName, uid);
      //  await _client.from('comments').delete().eq('channelId', channelId);
    } on PostgrestException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> reduceViewCount(String channelId, bool isInc) async {
    await _client.rpc(
      'increment_viewers',
      params: {'row_id': channelId, 'delta': isInc ? 1 : -1},
    );
  }

  addComment(String id, String name, String channelId, String content) async {
    try {
      await _client.from('comments').insert({
        'id': id,
        'channelId': channelId,
        'name': name,
        'content': content,
      });
    } on Exception catch (e) {
      debugPrint('Error in inserting the message:$e');
    }
  }
}
