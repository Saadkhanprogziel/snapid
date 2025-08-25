import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/register/register.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/network/network_repository.dart';

class AuthRespository {
  final networkRepository = NetworkRepository();

  Future<Either<String, dynamic>> register({
    required RegisterModel user,
  }) async {
    final response = await networkRepository.post(
        url: "/auth/user-register", data: user.toJson());
    print(response);
    {}
    if (response.success) {
      final data = UserModel.fromJson(response.data["data"]);
      appStorage.write("user", jsonEncode(data.toJson()));
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, UserModel>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response =
        await networkRepository.post(url: "/auth/login-user", data: {
      "emailORphone": emailOrPhone,
      "password": password,
    });

    if (!response.failed) {
      final data = UserModel.fromJson(response.data["data"]["user"]);
      appStorage.write("user", jsonEncode(data.toJson()));
      await getUserDetails();


      // appStorage.write("accessToken", response.data["data"]["accessToken"]);
      // appStorage.write("refreshToken", response.data["data"]["refreshToken"]);

      return right(data);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> forgotPassword(String email) async {
    final response =
        await networkRepository.post(url: "/auth/password-reset-link", data: {
      "emailAddress": email,
    });
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }

     /// ✅ Fixed and completed updateProfile
  Future<Either<String, bool>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    String? gender,
    String? password,
  }) async {
    final response = await networkRepository.post(
      url: "/auth/update-user-profile",
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        if (gender != null) "gender": gender,

      },
    );

    if (!response.failed) {
      // Refresh local user info
      await getUserDetails();
      return right(true);
    }
    return left(response.message);
  }


  Future<Either<String, bool>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response =
        await networkRepository.post(url: "/auth/reset-password", data: {
      "email": email,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    });
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> verifyOtp({
    required String identifier,
    required int code,
  }) async {
    final response =
        await networkRepository.post(url: "/auth/verify-otp", data: {
      "identifier": identifier,
      "otp": code,
    });
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> sendOtp(
      String identifier, String emailOrPhone) async {
    final response = await networkRepository.post(url: "/auth/send-otp", data: {
      "identifier": identifier,
      "sendTo": emailOrPhone,
    });
    if (response.success) {
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> reSendOtp(
    String identifier,
  ) async {
    final response =
        await networkRepository.post(url: "/auth/resend-otp", data: {
      "identifier": identifier,
    });
    if (response.success) {
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> logout() async {
    final response = await networkRepository.post(url: "/auth/logout-user");
    if (!response.failed) {
      
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, UserModel>> getUserDetails() async {
    final response = await networkRepository.get(url: "/auth/logged-user");
    if (!response.failed) {
      final data = UserModel.fromJson(response.data["data"]);
      // appStorage.write('user', data);
      appStorage.write("user", jsonEncode(data.toJson()));
      return right(data);
    }
    return left(response.message);
  }
}
