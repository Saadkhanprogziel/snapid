import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:snapid/constant/colors.dart';

class CustomCameraScreen extends StatefulWidget {
  @override
  _CustomCameraScreenState createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isInitialized = false;
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        controller = CameraController(
          cameras!.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await controller!.initialize();
        
        if (mounted) {
          setState(() {
            isInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      Get.back();
      Get.snackbar(
        'Camera Error', 
        'Failed to initialize camera',
        backgroundColor: AppColors.red,
        colorText: AppColors.whiteColor
      );
    }
  }

  Future<void> capturePhoto() async {
    if (!controller!.value.isInitialized || isCapturing) return;

    try {
      setState(() {
        isCapturing = true;
      });

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imagePath = path.join(
        appDir.path,
        'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile photo = await controller!.takePicture();
      
      // Copy the photo to our app directory
      await photo.saveTo(imagePath);
      
      // Return the image path
      Get.back(result: imagePath);
      
    } catch (e) {
      print('Error capturing photo: $e');
      Get.snackbar(
        'Capture Error', 
        'Failed to capture photo',
        backgroundColor: AppColors.red,
        colorText: AppColors.whiteColor
      );
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.whiteColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: controller!.value.aspectRatio,
              child: CameraPreview(controller!),
            ),
          ),
          
          // Top bar with back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          
          // Bottom controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Capture button
                GestureDetector(
                  onTap: isCapturing ? null : capturePhoto,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCapturing ? Colors.grey : Colors.white,
                      ),
                      child: isCapturing 
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}