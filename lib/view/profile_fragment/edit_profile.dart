
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';

import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

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
                  title: "Edit Profile",
                  showBackButton: true,
                ),
              ),
              SpaceH80(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Transform.translate(
                      offset: const Offset(0, -60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        'https://www.w3schools.com/howto/img_avatar.png',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 14,
                                          child: Icon(
                                            Icons.upload,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SpaceH20(),
                                const Text(
                                  'John Doe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'johndoe@gmail.com',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                CustomTextField(
                                  // controller: nameController,
                                  label: 'First Name',
                                  hintText: 'First Name',
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  // controller: nameController,
                                  label: 'Last Name',
                                  hintText: 'Last Name',
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  // controller: nameController,
                                  label: 'Email',
                                  hintText: 'johndoe@example.com',
                                  prefixIcon: Icons.email,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  // controller: nameController,
                                  label: 'Phone',
                                  hintText: '+1 564 655 555',
                                  prefixIcon: Icons.phone,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  // controller: nameController,
                                  label: 'Country',
                                  hintText: 'United State',
                                  prefixIcon: Icons.flag,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  // controller: nameController,
                                  label: 'Language',
                                  hintText: 'English',
                                  prefixIcon: Icons.language,
                                ),
                                const SizedBox(height: 16),
                               
                              ],
                            ),
                          )),
                          SpaceH20(),
                          Row(
                            children: [
                              SpaceW12(),
                              Expanded(
                                  child: CustomOutlineButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      label: "Cancel")),
                              SpaceW12(),
                              Expanded(
                                  child: CustomElevatedButton(
                                      onPressed: () {}, text: "Save"))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
