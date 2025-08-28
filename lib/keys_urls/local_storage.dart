

import 'dart:convert';

import 'package:snapid/main.dart';
import 'package:snapid/models/user/user_model.dart';

class LocalStorage {

  String getBearerToken() {
    final token = appStorage.read('userToken');
    return token != null ? '$token' : '';
  }

  String getName() {
    final name = appStorage.read('name');
    return name != null ? '$name' : '';
  }
  bool canDownload() {
    int credits = appStorage.read('credits') ?? 0;
    return credits > 0 ? true : false;
  }

  String getEmail() {
    final email = appStorage.read('email');
    return email != null ? '$email' : '';
  }

  static UserModel? getUser() {
    final user = appStorage.read("user")?.toString() ?? "";
    if (user.isNotEmpty) {
      final data = jsonDecode(user);
      final parsedUser = UserModel.fromJson(data);
      return parsedUser;
    }
    return null;
  }
}
