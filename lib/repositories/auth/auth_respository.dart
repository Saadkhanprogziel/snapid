import 'dart:convert';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapid/keys_urls/urls.dart';
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

  
   Future<Either<String, bool>> createGuestUser() async {
    final response =
        await networkRepository.post(url: "/auth/create-web-guest-user", data: {
          "guestID": null
    });
    if (!response.failed) {
         final id = response.data["data"]['id'];
         print("Guest User ID: $id"); 
               appStorage.write("guest_id", id);

      return right(true);
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
  required List<XFile> file,
}) async {
  try {
    print("Updating profile with ${file.length} file(s)");

    // Prepare fields
    final fields = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };

    // Prepare files differently for web vs mobile
    final Map<String, dynamic> multipleFiles = {};

    if (kIsWeb) {
      final fileList = <Map<String, dynamic>>[];

      for (final f in file) {
        Uint8List bytes = await f.readAsBytes();
        fileList.add({
          'bytes': bytes,
          'filename': f.name,
        });
      }

      multipleFiles['profilePicLocalPath'] = fileList;
    } else {
      final files = file.map((x) => File(x.path)).toList();
      multipleFiles['profilePicLocalPath'] = files;
    }

    // Prepare formData
    final formData = await networkRepository.createFormData(
      fields: fields,
      multipleFiles: multipleFiles,
    );

    final token = appStorage.read("token") ?? "";
    final headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    // Send multipart request
    final response = await networkRepository.postMultipart(
      url: '${apiUrl}/auth/update-user-profile',
      formData: formData,
      headers: headers,
    );

    if (response.success) {
      return const Right(true);
    } else {
      return Left(response.message);
    }
  } catch (e) {
    return Left('Error updating profile: ${e.toString()}');
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
