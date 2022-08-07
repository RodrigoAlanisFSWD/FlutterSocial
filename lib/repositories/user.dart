import 'dart:io';

import 'package:client/main.dart';
import 'package:client/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserRepositories {
  static String mainUrl = "http://192.168.100.76:8080/api/";
  var loginUrl = '$mainUrl/auth/sign-in';
  var registerUrl = '$mainUrl/auth/sign-up';
  var profileUrl = '$mainUrl/user/profile';
  var avatarUrl = '$mainUrl/user/avatar';

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<bool> hasToken() async {
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

  Future<void> deleteToken() async {
    storage.delete(key: 'token');
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

  Future<String> login(String email, String password) async {
    Response res =
        await _dio.post(loginUrl, data: {"email": email, "password": password});

    return res.data["token"];
  }

  Future<String> register(
      String username, String email, String password) async {
    Response res = await _dio.post(registerUrl,
        data: {"username": username, "email": email, "password": password});

    return res.data["token"];
  }

  Future<User> getProfile() async {
    Response res = await _dio.get(profileUrl,
        options: Options(headers: {
          "Authorization": "Bearer ${await getToken()}",
        }));

    return User(
        id: res.data["user"]["id"],
        email: res.data["user"]["email"],
        username: res.data["user"]["username"]);
  }

  Future<int> uploadAvatar(File avatar, String token) async {
    String fileName = avatar.path.split('/').last;
    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(avatar.path, filename: fileName)
    });

    Response res = await _dio.post(avatarUrl,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return res.statusCode as int;
  }
}
