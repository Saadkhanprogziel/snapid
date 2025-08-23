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
    final args = Get.arguments as Map<String, dynamic>;
    email = args["email"] ?? "";
    phone = args["phone"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              Assets.appBg,
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SnapID Title Section
              Column(
                children: [
                  Text(
                    "Verify Your Identity",
                    style: CustomTextTheme.headingLarge
                        .copyWith(fontSize: 32, color: AppColors.whiteColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Select how you'd like to receive \nthe verification code.",
                    textAlign: TextAlign.center,
                    style: CustomTextTheme.regular16.copyWith(
                      color: Colors.white70,
                      // fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(10, 223, 222, 222),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildRadioTile(
                                  value: ContactMethod.email,
                                  groupValue: _selectedMethod,
                                  title: "Send code to email",
                                  subtitle: email,
                                ),
                                SizedBox(height: 40),
                                _buildRadioTile(
                                  value: ContactMethod.mobile,
                                  groupValue: _selectedMethod,
                                  title: "Send code to mobile",
                                  subtitle: phone,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    final identifier =
                        _selectedMethod == ContactMethod.email ? email : phone;
                    final sendTo = _selectedMethod == ContactMethod.email
                        ? "emailAddress"
                        : "phoneNumber";

                    final result =
                        await authRepository.sendOtp(identifier, sendTo);

                    result.fold(
                      (failureMessage) {
                        // LEFT = error
                        Get.snackbar(
                          "Error",
                          failureMessage,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      },
                      (success) {
                        // RIGHT = success
                        Get.toNamed(
                          PrimaryRoute.otpScreen,
                          arguments: {
                            "identifier": identifier,
                          },
                        );
                      },
                    );

                     Get.toNamed(
                          PrimaryRoute.otpScreen,
                          arguments: {
                            "identifier": identifier,
                          },
                        );
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize:
                        const Size.fromHeight(60), // Changed from 50 to 55
                  ),
                  child: Text(
                    "Continue",
                    style: CustomTextTheme.regular16
                        .copyWith(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            margin: EdgeInsets.only(right: 16),
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
                      decoration: BoxDecoration(
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
              SizedBox(height: 4),
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
