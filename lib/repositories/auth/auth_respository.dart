import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/network/network_repository.dart';

class AuthRespository {
  final networkRepository = NetworkRepository();

  Future<Either<String, bool>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String countryCode,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await networkRepository.post(url: "/auth/register", data: {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "gender": gender,
      "country_code": countryCode,
      "phone_number": phoneNumber,
      "password": password,
      "confirm_password": confirmPassword,
    });
    if (!response.failed) {
      final data = UserModel.fromJson(response.data["data"]);
      appStorage.write('user', data);
      appStorage.write("user", jsonEncode(data.toJson()));
      return right(true);
    }
    return left(response.message);
  }

Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {

    final response = await networkRepository.post(url: "/auth/login", data: {
      "email": email,
      "password": password,
    });
    if (!response.failed) {
      final data = UserModel.fromJson(response.data["data"]);
      appStorage.write('user', data);
     
      
      appStorage.write("user", jsonEncode(data.toJson()));
      return right(data);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> forgotPassword(String email) async {
    final response = await networkRepository.post(url: "/auth/forgot-password", data: {
      "email": email,
    });
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }


  Future<Either<String, bool>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await networkRepository.post(url: "/auth/reset-password", data: {
      "email": email,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    });
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> verifyEmail({
    required String email,
    required String code,
  }) async {
    final response = await networkRepository.post(url: "/auth/verify-email", data: {
      "email": email,
      "code": code,
    });
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }


  Future<Either<String, bool>> resendVerificationEmail(String email) async {
    final response = await networkRepository.post(url: "/auth/resend-verification-email", data: {
      "email": email,
    });
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }


  


  Future<Either<String, bool>> logout() async {
    final response = await networkRepository.post(url: "/auth/logout");
    if (!response.failed) {
      appStorage.erase();
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, UserModel>> getUserDetails() async {
    final response = await networkRepository.get(url: "/auth/user");
    if (!response.failed) {
      final data = UserModel.fromJson(response.data["data"]);
      appStorage.write('user', data);
      appStorage.write("user", jsonEncode(data.toJson()));
      return right(data);
    }
    return left(response.message);
  }



 
}