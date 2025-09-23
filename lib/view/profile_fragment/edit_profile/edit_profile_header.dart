import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/controllers/profile/edit_profile_controller.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class ProfileHeader extends StatelessWidget {
  final EditProfileController controller;

  const ProfileHeader({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Obx(() {
                  if (controller.selectedPhotos.isNotEmpty) {
                    return Image(
                      image: controller.selectedPhotos.first,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    );
                  } else if (controller.profileImageUrl.value.isNotEmpty) {
                    return Image.network(
                      controller.profileImageUrl.value,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultImage();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildLoadingContainer();
                      },
                    );
                  } else {
                    return _buildDefaultImage();
                  }
                }),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => controller.pickImages(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              // Loading overlay when uploading
              Obx(() {
                if (controller.isLoading.value) {
                  return Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          const SpaceH20(),
          Text(
            '${controller.editProfile.firstName ?? ''} ${controller.editProfile.lastName ?? ''}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            controller.editProfile.email ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Image.network(
      'https://avatar.iran.liara.run/public/boy',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
  }

  Widget _buildLoadingContainer() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
