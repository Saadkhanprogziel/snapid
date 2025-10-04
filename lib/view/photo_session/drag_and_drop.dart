import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';

class ImageDragAndDrop extends StatefulWidget {
  const ImageDragAndDrop({Key? key}) : super(key: key);

  @override
  State<ImageDragAndDrop> createState() => ImageoDragAndDropState();
}

class ImageoDragAndDropState extends State<ImageDragAndDrop> {
  bool _dragging = false;
  final controller = Get.find<PhotoController>();

  Future<void> _pickImage(ImageSource source) async {
    controller.selectedPhotos.clear();
    controller.capturedPhotos.clear();

    if (source == ImageSource.camera) {
      await controller.capturePhotosSimple();
    } else {
      await controller.pickImages(allowMultiple: true);
      if (controller.capturedPhotos.isNotEmpty) {
        Get.toNamed(PrimaryRoute.selectedPhoto);
      }
    }
  }

  


  Future<void> _handleDrop(List<XFile> files) async {
    controller.selectedPhotos.clear();
    controller.capturedPhotos.clear();

    for (final file in files) {
      controller.capturedPhotos.add(file);
      final bytes = await file.readAsBytes();
      controller.selectedPhotos.add(MemoryImage(bytes));
    }

    Get.toNamed(PrimaryRoute.selectedPhoto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: LayoutBuilder(builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;
          return Center(
            child: DropTarget(
              onDragDone: (detail) => _handleDrop(detail.files),
              onDragEntered: (_) => setState(() => _dragging = true),
              onDragExited: (_) => setState(() => _dragging = false),
              child: Container(
                width: width > 900 ? 900 : width * 0.98,
                height: height > 700 ? 700 : height * 0.92,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _dragging ? Colors.deepPurple : Colors.grey.shade300,
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 👇 Replace with your illustration asset
                    const Icon(Icons.cloud_upload_outlined,
                        size: 72, color: AppColors.primaryColor),
                    const SizedBox(height: 20),
                    const Text(
                      "Drag & drop your photo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Or", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Outlined button
                        SizedBox(
                            width: 160,
                            height: 48,
                            child: CustomOutlineButton(
                              onPressed: () {
                                _pickImage(ImageSource.camera);
                              },
                              label: "Take a Picture",
                              minHeight: 60,
                              textColor: Colors.grey,
                              borderColor: Colors.grey,
                            )),
                        const SizedBox(width: 16),

                        // Filled gradient button
                        SizedBox(
                          width: 160,
                          height: 48,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6A5AE0),
                                    Color(0xFF5840EC)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomElevatedButton(
                                onPressed: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                text: "Upload a Image",
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
