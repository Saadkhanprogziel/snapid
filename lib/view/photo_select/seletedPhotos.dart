import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/controllers/photoController/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';

class SelectedPhotosScreen extends StatelessWidget {
  final PhotoController controller = Get.find<PhotoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.appBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                child: CustomHeader(
                  title: "Selected Photos",
                  showBackButton: true,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() {
                    final count = controller.selectedPhotos.length;
                    return GridView.builder(
                      itemCount: 5,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (ctx, index) {
                        if (index < count) {
                          final img = controller.selectedPhotos[index];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: img,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => controller.removePhoto(index),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.remove,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              controller.pickImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          );
                        }
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "You can upload up to 5 photos for best AI results.",
                style: TextStyle(color: Colors.white60),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomElevatedButton(
                  onPressed: () {
                    Get.toNamed(PrimaryRoute.photo_creation);
                    controller.setStep(2);
                  },
                  text: "Continue",
                  minHeight: 60,
                ),
              ),
              SizedBox(height: 20), // Add bottom spacing if needed
            ],
          ),
        ],
      ),
    );
  }
}
