import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/profile/report_bug/report_bug_controller.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/screenBg.dart';

class ReportBug extends StatelessWidget {
  ReportBug({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportBugController controller = Get.put(ReportBugController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          buildBackground(),

          /// Main content
          Column(
            children: [
              SafeArea(
                child: CustomHeader(
                  title: "Report a Bug",
                  showBackButton: true,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpaceH30(),

                      // Issue Category Label
                      const Text(
                        'Issue Category',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Category Dropdown
                      Obx(() => Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A3A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF3A3A4A),
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedCategory.value.isEmpty
                                    ? null
                                    : controller.selectedCategory.value,
                                hint: const Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    'Select Category',
                                    style: TextStyle(
                                      color: Color(0xFF8A8A9A),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                icon: const Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF8A8A9A),
                                  ),
                                ),
                                isExpanded: true,
                                dropdownColor: const Color(0xFF2A2A3A),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                items: controller.categories
                                    .map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(category),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  controller.selectedCategory.value =
                                      newValue ?? '';
                                },
                              ),
                            ),
                          )),

                      const SizedBox(height: 30),

                      // Description Label
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description Text Area
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A3A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF3A3A4A),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller.descriptionController,
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Describe what happened...',
                            hintStyle: TextStyle(
                              color: Color(0xFF8A8A9A),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Photo Section
                      Obx(() {
                        if (controller.selectedImage.value != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Added Photo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A3A),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF3A3A4A),
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        controller.selectedImage.value!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: controller.removePhoto,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Change photo button
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    controller.addPhoto();
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Change Photo',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF3A3A4A),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                controller.addPhoto();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Add a Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),

                      const SizedBox(height: 120), // space before button
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// Button pinned at bottom inside stack
         Positioned(
  left: 20,
  right: 20,
  bottom: 20,
  child: SafeArea(
    child: CustomElevatedButton(
      onPressed: () {
        if (!controller.isLoading.value) {
          controller.sendReport();
        }
      },
      text: "Send Report",
      minHeight: 60,
    ),
  ),
),

/// Loader overlay at center
Obx(() => controller.isLoading.value
    ? Container(
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      )
    : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
