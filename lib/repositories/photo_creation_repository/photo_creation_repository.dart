import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:snapid/keys_urls/urls.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/network/network_repository.dart';
import 'dart:io' show File;

class PhotoCreationRepository {
  final NetworkRepository _networkRepository = NetworkRepository();

  Future<Either<String, PhotoCreationModel>> createPhotoSession({
    required String countryCode,
    required String documentType,
    required List<XFile> userSessionPhotos,
    required String platform,
    double? customWidth,
    double? customHeight,
  }) async {
    try {
      print("Creating photo session with ${userSessionPhotos.length} photos");
      print("Document Type: $documentType");

      // Prepare fields
      final fields = <String, dynamic>{
        'countryCode': countryCode,
        'platform': platform,
      };

      if (documentType != 'MANUAL_INPUT') {
        fields['documentType'] = documentType;
      }

      if (customWidth != null && customWidth > 0) {
        fields['customWidth'] = customWidth;
      }
      if (customHeight != null && customHeight > 0) {
        fields['customHeight'] = customHeight;
      }

      // Prepare files differently for web vs mobile
      final Map<String, dynamic> multipleFiles = {};

      if (kIsWeb) {
        final fileList = <Map<String, dynamic>>[];

        for (final photo in userSessionPhotos) {
          Uint8List bytes = await photo.readAsBytes();
          fileList.add({
            'bytes': bytes,
            'filename': photo.name,
          });
        }

        multipleFiles['userSessionPhotos'] = fileList;
      } else {
        final files = userSessionPhotos.map((x) => File(x.path)).toList();
        multipleFiles['userSessionPhotos'] = files;
      }

      final formData = await _networkRepository.createFormData(
        fields: fields,
        multipleFiles: multipleFiles,
      );

      final token = appStorage.read("token") ?? "";
      final headers = <String, String>{
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };

      var url = '$apiUrl/session/start-session';
      final guestId = appStorage.read("guest_id");
      if (guestId != null && token.isEmpty) {
        // headers['guestID'] = guestId;
        url = '$apiUrl/session/start-guest-session/$guestId';
      }

      final response = await _networkRepository.postMultipart(
        url: url,
        formData: formData,
        headers: headers,
      );

      if (response.success) {
        
          final id = response.data["data"]['id'];
          print("session_ID $id");
          appStorage.write("session_id", id);
        final photoCreationModel =
            PhotoCreationModel.fromJson(response.data['data']);
        return Right(photoCreationModel);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('Error creating photo session: ${e.toString()}');
    }
  }

  Future<Either<String, String>> createPayment(
    String paymentId,
    String email,
    String planID,

  ) async {
    try {
      final sessionId = appStorage.read("session_id");
      final guestId = appStorage.read("guest_id");
      var url = '/credits/create-payment';
      if (guestId != null) {
        url = '/credits/create-web-payment/$guestId';
        
      }
      final response = await _networkRepository.post(
        url: url,
        data: {
          "paymentMethodID": paymentId,
          "email": email,
          "planID":  planID, 
          "currency": "usd",
          "photoSessionID": sessionId
        },
      );

      if (response.success) {
        var paymentData = response.data['paymentIntentId'];

        return Right(paymentData);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('Error downloading image: ${e.toString()}');
    }
  }

  Future<Either<String, String>> confirmPayment(
    String paymentIntentId,
    String email,
  ) async {
    try {
      final sessionId = appStorage.read("session_id");
      final response = await _networkRepository.post(
        url: '/credits/confirm-web-payment',
        data: {
          "paymentIntentId": paymentIntentId,
          "email": email,
          "currency": "usd",
          "photoSessionID": sessionId
        },
      );

      if (response.success) {
        var paymentData = response.data['transactionId'];

        return Right(paymentData);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('Error downloading image: ${e.toString()}');
    }
  }

  Future<Either<String, PhotoCreationModel>> downloadImage({
    required String id,
  }) async {
    try {
      var url = '$apiUrl/session/download-photo';
      final token = appStorage.read("token") ?? "";
     
      final guestId = appStorage.read("guest_id");
      if (guestId != null && token.isEmpty) {
        // headers['guestID'] = guestId;
        url = '$apiUrl/session/download-web-photo/$id/$guestId';
      }
      final response = await _networkRepository.post(
        url: url,
        data: {'sessionID': id},
      );

      if (response.success) {
        final photoCreationModel =
            PhotoCreationModel.fromJson(response.data['data']);
        return Right(photoCreationModel);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('Error downloading image: ${e.toString()}');
    }
  }
}
