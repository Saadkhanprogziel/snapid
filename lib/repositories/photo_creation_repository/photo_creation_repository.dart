import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:snapid/keys_urls/urls.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';

class PhotoCreationRepository {
  final Dio _dio = Dio();

  Future<Either<String, PhotoCreationModel>> createPhotoSession({
    required String countryCode,
    required String documentType,
    required List<File> userSessionPhotos,
    required String platform,
    double? customWidth,
    double? customHeight,
  }) async {
    try {
      // Create FormData for multipart request
      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry('countryCode', countryCode),
        MapEntry('documentType', "DRIVING_LICENSE"),
        MapEntry('platform', platform),
      ]);


      // Add custom dimensions if provided
      if (customWidth != null) {
        formData.fields.add(MapEntry('customWidth', customWidth.toString()));
      }
      if (customHeight != null) {
        formData.fields.add(MapEntry('customHeight', customHeight.toString()));
      }

      // Add files to form data
      for (File file in userSessionPhotos) {
        formData.files.add(
          MapEntry(
            'userSessionPhotos',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      // Set base URL - replace with your actual API base URL
      const String baseUrl = apiUrl;
            final token = appStorage.read("token") ?? "";

      // Configure headers if needed
      _dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        // Add any other headers like authorization if needed
        'Authorization': 'Bearer $token',
      };

      // Make the API call
      final response = await _dio.post(
        '$baseUrl/session/start-session',
        data: formData,
      );

      if (response.statusCode == 200) {
        final photoCreationModel = PhotoCreationModel.fromJson(response.data);
        
        return Right(photoCreationModel);
      } else {
        return Left('Failed to create photo session: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        return Left('API Error: ${e.response!.statusCode} - ${e.response!.data}');
      } else {
        return Left('Network Error: ${e.message}');
      }
    } catch (e) {
      return Left('Error creating photo session: ${e.toString()}');
    }
  }
}