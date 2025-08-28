import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/register/register.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/network/network_repository.dart';
import 'package:snapid/routes/routes.dart';

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
      print("nahi hai");
      final data = UserModel.fromJson(response.data["data"]["user"]);
      appStorage.write("user", jsonEncode(data.toJson()));
      await getUserDetails();

      return right(data);
    }
    if (response.message == "Please Verify your account.") {
      final dataString = response.data["data"];
     Get.toNamed(PrimaryRoute.verification, arguments: {
        "email": dataString['userMail'],
        "phone": "${dataString['userPhone']}",
      });
      return left(response.message);
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

  Future<Either<String, bool>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    String? gender,
    String? password,
    File? profileImage,
  }) async {
    try {
      // Prepare fields
      final fields = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
        if (password != null && password.isNotEmpty) 'password': password,
      };

      final files = <String, File>{};
      if (profileImage != null && profileImage.existsSync()) {
        files['profilePicLocalPath'] = profileImage;
      }

      // Use existing helper in NetworkRepository
      final formData = await networkRepository.createFormData(
        fields: fields,
        files: files.isNotEmpty ? files : null,
      );

      // Call multipart post
      final response = await networkRepository.postMultipart(
        url: "/auth/update-user-profile",
        formData: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );

      if (!response.failed) {
        await getUserDetails();
        return right(true);
      }
      return left(response.message);
    } catch (e) {
      return left("Failed to update profile: ${e.toString()}");
    }
  }

  // 
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


Future<Either<String, bool>> deleteProfile(
  {required String reason}
){
    return networkRepository.delete(url: "/auth/delete-profile",data: {
      "reason": reason
    }).then((response) async {
      if (!response.failed) {
      await removeUserData();
        return right(true);
      }
      return left(response.message);
    });
}

Future<Either<String, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await networkRepository.post(
        url: "/auth/change-password",
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmNewPassword": confirmPassword,

        });
    if (!response.failed) {
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
      await removeUserData();
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


Future<void> removeUserData() async {
  bool biometric = appStorage.read("biometric_enabled") ?? false;
    try {
      await appStorage.remove('user');
      await appStorage.remove('token');
      await appStorage.remove('refreshToken');
      if (biometric) {
      await appStorage.remove('biometric_enabled');
        
      }
    } catch (e) {
      print("Error removing user data: $e");
    }
  }
}
