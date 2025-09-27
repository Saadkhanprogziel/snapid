import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/routes/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final token = appStorage.read("token");
    if (token == null || token.toString().isEmpty) {
      return const RouteSettings(name: PrimaryRoute.login);
    }
    // Otherwise, allow the route
    return null;
  }
  @override
  int? priority = 0;
}