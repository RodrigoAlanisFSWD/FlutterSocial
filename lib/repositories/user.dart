import 'dart:io';

import 'package:client/main.dart';
import 'package:client/models/tokens.dart';
import 'package:client/models/user.dart';
import 'package:client/repositories/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserRepositories {
  var loginUrl = '/auth/sign-in';
  var registerUrl = '/auth/sign-up';
  var profileUrl = '/user/profile';
  var avatarUrl = '/user/avatar';

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final RequestRepositories requestRepositories = RequestRepositories();

  Future<bool> hasToken() async {
    requestRepositories.initApiClient();
    var value = await storage.read(key: 'token');

    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> persisteToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> saveRefresh(String refresh) async {
    await storage.write(key: 'refresh', value: refresh);
  }

  Future<void> deleteTokens() async {
    storage.delete(key: 'token');
    storage.delete(key: 'refresh');
    storage.deleteAll();
  }

  Future<String?> getToken() async {
    var value = await storage.read(key: 'token');

    if (value != null) {
      return value;
    } else {
      return null;
    }
  }

  Future<Tokens> login(String email, String password) async {
    Response res = await requestRepositories.dio
        .post(loginUrl, data: {"email": email, "password": password});

    return Tokens(token: res.data["token"], refresh: res.data["refresh"]);
  }

  Future<Tokens> register(
      String username, String email, String password) async {
    Response res = await requestRepositories.dio.post(registerUrl,
        data: {"username": username, "email": email, "password": password});

    return Tokens(token: res.data["token"], refresh: res.data["refresh"]);
  }

  Future<User> getProfile() async {
    Response res = await requestRepositories.dio.get(
      profileUrl,
    );

    return User(
        id: res.data["user"]["id"],
        email: res.data["user"]["email"],
        username: res.data["user"]["username"],
        avatarUrl: res.data["user"]["avatarUrl"]);
  }

  Future<int> uploadAvatar(File avatar, String token) async {
    String fileName = avatar.path.split('/').last;
    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(avatar.path, filename: fileName)
    });

    Response res = await requestRepositories.dio.post(
      avatarUrl,
      data: formData,
    );

    return res.statusCode as int;
  }
}
