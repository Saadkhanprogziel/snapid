import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/profile/edit_profile_controller.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/view/profile_fragment/edit_profile/edit_profile_form_card.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isWide = deviceWidth >= 800;

    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) {
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
              Padding(
                padding: EdgeInsets.all(isWide ? 20 : 0),
                child: Column(
                  children: [
                    SafeArea(
                      child: CustomHeader(
                        title: "Edit Profile",
                        showBackButton: true,
                      ),
                    ),
                    SpaceH80(),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWideScreen = constraints.maxWidth > 800;
                          
                          return Center(
                            child: Container(
                              width: isWideScreen ? constraints.maxWidth * 0.8 : double.infinity,
                              margin: isWideScreen ? const EdgeInsets.all(20) : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(isWideScreen ? 20 : 60),
                                  topRight: Radius.circular(isWideScreen ? 20 : 60),
                                  bottomLeft: Radius.circular(isWideScreen ? 20 : 0),
                                  bottomRight: Radius.circular(isWideScreen ? 20 : 0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isWideScreen ? 40 : 30,
                                ),
                                child: Transform.translate(
                                  offset: Offset(0, isWideScreen ? -30 : -60),
                                  child: ProfileFormCard(
                                    formKey: _formKey,
                                    controller: controller,
                                    isWideScreen: isWideScreen,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}