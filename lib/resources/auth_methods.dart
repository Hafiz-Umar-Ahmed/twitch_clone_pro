import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitch_clone_pro/provider/user_provider.dart';
import 'package:twitch_clone_pro/utils/utils.dart';

import '../model/user.dart' as model;

class AuthMethods {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getUser(String? uid) async {
    if (uid == null) return null;
    final response = await _client
        .from('users')
        .select()
        .eq('uid', uid)
        .single();
    return response;
  }

  Future<bool> signUpUser(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async {
    bool res = false;
    try {
      final response = await _client.auth.signUp(
        password: password,
        email: email,
      );
      final user = response.user;
      if (user != null) {
        model.User modelUser = model.User(
          username: username.trim(),
          email: email.trim(),
          uid: user.id,
        );
        await _client.from('users').insert(modelUser.toMap());
        Provider.of<UserProvider>(context, listen: false).setUser(modelUser);
        res = true;
      }
    } on AuthException catch (e) {
      showSnackBar(context, e.message);
    }
    return res;
  }

  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    bool res = false;

    try {
      final response = await _client.auth.signInWithPassword(
        password: password.trim(),
        email: email.trim(),
      );
      final user = response.user;
      if (user != null) {
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUser(model.User.fromMap(await getUser(user.id) ?? {}));
        res = true;
      }
    } on AuthException catch (e) {
      showSnackBar(context, e.message);
    }
    return res;
  }
}
