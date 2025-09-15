import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';

class SelectedPhotosScreen extends StatelessWidget {
  final PhotoController controller = Get.find<PhotoController>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;
    final bool isDesktop = deviceWidth >= 1000;
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
                        crossAxisCount: isMobile ? 2 : 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: !isDesktop ? 1 : 1.8,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                                  height: double.infinity,
                                  // ✅ Add error handling for web compatibility
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Image load error: $error');
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                    );
                                  },
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
              SizedBox(height: 10),
              Text(
                "You can upload up to 5 photos for best AI results.",
                style: TextStyle(color: Colors.white60),
              ),
              SizedBox(height: 10),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: isDesktop ? 200:40),
                child: CustomElevatedButton(
                  onPressed: () {
                    if (controller.selectedPhotos.isEmpty) {
                      Get.snackbar(
                          "No Photos", "Please select at least one photo.",
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }
                    if (controller.selectedPhotos.length < 3) {
                      Get.snackbar("Insufficient Photos",
                          "Please select at least three photos for better results.",
                          backgroundColor: Colors.orange,
                          colorText: Colors.white);
                      return;
                    }
                    Get.toNamed(PrimaryRoute.photo_creation,
                        arguments: {"fromSelection": true});
                    controller.setStep(2);
                  },
                  text: "Continue",
                  minHeight: isDesktop ? 70:60,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}