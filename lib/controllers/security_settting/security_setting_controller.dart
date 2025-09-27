import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/message_popup.dart';

class SecuritySettingController extends GetxController {
  AuthRespository authRespository = AuthRespository();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
    String selectedReason = '';

  void setReason(String reason) {
    selectedReason = reason;
    update();
  }

  

  bool currentObscure = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  void toggleObscureNew() {
    obscureNew = !obscureNew;
    update(); // 👈 force GetBuilder to rebuild
  }

  void toggleObscureCurrent() {
    currentObscure = !currentObscure;
    update(); // 👈 force GetBuilder to rebuild
  }

  void toggleObscureConfirm() {
    obscureConfirm = !obscureConfirm;
    update(); // 👈 force GetBuilder to rebuild
  }

  void changePassword()  {
    isLoading = true;
    update();
    authRespository
        .changePassword(
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
          confirmPassword: confirmPasswordController.text,
        )
        .then((response) => response.fold((error) {
              isLoading = false;
              update();
              Get.snackbar("Error", error,
                  backgroundColor: Colors.red, colorText: Colors.white);
            }, (success) async {
              isLoading = false;
              update();
              Get.dialog(
                CustomMessagePopUp(
                  title: 'Password Updated',
                  message:
                      'Your password has been Changed successfully. You can now log in with your new credentials.',
                ),
                barrierDismissible: false,
              );
              await Future.delayed(const Duration(seconds: 2), () {
                Get.back(); // Close dialog
                Get.back(); // Close dialog
              });
              // Get.back();
            }));
  }


  void onDeleteProfile(){
    authRespository.deleteProfile(reason: selectedReason
    ).then((response) => response.fold((error) {
          isLoading = false;
          update();
          Get.snackbar("Error", error,
              backgroundColor: Colors.red, colorText: Colors.white);
        }, (success) async {
          isLoading = false;
          update();
          Get.dialog(
            CustomMessagePopUp(
              title: 'Profile Deleted',
              message:
                  'Your profile has been deleted successfully.',
            ),
            barrierDismissible: false,
          );
          await Future.delayed(const Duration(seconds: 2), () {
           Get.offNamed(PrimaryRoute.login);
          });
          // Get.back();
        })
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
