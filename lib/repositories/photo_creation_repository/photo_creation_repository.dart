import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:snapid/keys_urls/urls.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/network/network_repository.dart';

class PhotoCreationRepository {
  final NetworkRepository _networkRepository = NetworkRepository();

  Future<Either<String, PhotoCreationModel>> createPhotoSession({
    required String countryCode,
    required String documentType,
    required List<File> userSessionPhotos,
    required String platform,
    double? customWidth,
    double? customHeight,
  }) async {
    try {
      print("Creating photo session with ${userSessionPhotos.length} photos");
      print("Document Type: $documentType");

      // Prepare fields for FormData
      final fields = <String, dynamic>{
        'countryCode': countryCode,
        'platform': platform,
      };

      // Only send documentType if it's not MANUAL_INPUT
      if (documentType != 'MANUAL_INPUT') {
        fields['documentType'] = documentType;
      }

      if (customWidth != null && customWidth > 0) {
        fields['customWidth'] = customWidth;
      }
      if (customHeight != null && customHeight > 0) {
        fields['customHeight'] = customHeight;
      }

      final formData = await _networkRepository.createFormData(
        fields: fields,
        multipleFiles: {
          'userSessionPhotos': userSessionPhotos,
        },
      );

      // Prepare headers
      final token = appStorage.read("token") ?? "";
      final headers = <String, String>{
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };

      // Make the API call using NetworkRepository
      final response = await _networkRepository.postMultipart(
        url: '$apiUrl/session/start-session',
        formData: formData,
        headers: headers,
      );

      if (response.success) {
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

  Future<Either<String, PhotoCreationModel>> downloadImage({
    required String id,
  }) async {
    try {
      // Call API endpoint (replace with actual download URL)
      final response = await _networkRepository.post(
        url: '/session/download-photo',
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
