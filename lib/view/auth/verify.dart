import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

enum ContactMethod { email, mobile }

class _VerificationScreenState extends State<VerificationScreen> {
  ContactMethod _selectedMethod = ContactMethod.email;
  AuthRespository authRepository = AuthRespository();

  late String email;
  late String phone;

  @override
  void initState() {
    super.initState();
    
    final args = Map<String, dynamic>.from(Get.arguments ?? {});
    email = args["email"] ?? "";
    phone = args["phone"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          SizedBox.expand(
            child: Image.asset(
              Assets.appBg,
              fit: BoxFit.cover,
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 800;

              if (isWideScreen) {
                
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              Assets.verify_screen,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildOptionsCard(context, isWideScreen),
                      ),
                    ],
                  ),
                );
              } else {
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildOptionsCard(context, isWideScreen),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  
  Widget _buildOptionsCard(BuildContext context, bool isWideScreen) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Verify Your Identity",
                  style: CustomTextTheme.headingLarge.copyWith(
                    fontSize: 32,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Select how you'd like to receive \nthe verification code.",
                  textAlign: TextAlign.center,
                  style: CustomTextTheme.regular16.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: isWideScreen ? 600 : 450, 
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(20, 223, 222, 222),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRadioTile(
                    value: ContactMethod.email,
                    groupValue: _selectedMethod,
                    title: "Send code to email",
                    subtitle: email.isNotEmpty ? email : "No email provided",
                  ),
                  const SizedBox(height: 40),
                  _buildRadioTile(
                    value: ContactMethod.mobile,
                    groupValue: _selectedMethod,
                    title: "Send code to mobile",
                    subtitle: phone.isNotEmpty ? phone : "No phone provided",
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      final identifier =
                          _selectedMethod == ContactMethod.email
                              ? email
                              : phone;
                      final sendTo = _selectedMethod == ContactMethod.email
                          ? "emailAddress"
                          : "phoneNumber";
        
                      if (identifier.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "No ${sendTo == 'emailAddress' ? 'email' : 'phone'} provided.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
        
                      final result =
                          await authRepository.sendOtp(identifier, sendTo);
        
                      result.fold(
                        (failureMessage) {
                          Get.snackbar(
                            "Error",
                            failureMessage,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        },
                        (success) {
                          Get.toNamed(
                            PrimaryRoute.otpScreen,
                            arguments: {"identifier": identifier},
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: Text(
                      "Continue",
                      style: CustomTextTheme.regular16
                          .copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildRadioTile({
    required ContactMethod value,
    required ContactMethod groupValue,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => setState(() => _selectedMethod = value),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.deepPurpleAccent,
                width: 2,
              ),
              color: isSelected ? Colors.deepPurpleAccent : Colors.transparent,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomTextTheme.bold16
                    .copyWith(color: AppColors.whiteColor),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
