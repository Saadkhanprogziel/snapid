import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/main.dart';
import 'package:snapid/repositories/photo_creation_repository/photo_creation_repository.dart';

class StripeController extends GetxController {
  final PhotoCreationRepository photoCreationRepository = PhotoCreationRepository();
  PhotoController photoController = Get.find<PhotoController>();  

  final TextEditingController email = TextEditingController();
  final paymentMethodId = ''.obs;
  final isStripeLoading = false.obs;
  var isCardLoading = false.obs;
  // final cardEditController = CardEditController();


  // Future<void> createPaymentMethodWeb() async {
  //   try {
  //     isStripeLoading.value = true;
  //     // Also set the photo controller loading state
  //     photoController.isLoading.value = true;

  //     final paymentMethod = await WebStripe.instance.createPaymentMethod(
  //       const PaymentMethodParams.card(
  //         paymentMethodData: PaymentMethodData(
  //           billingDetails: BillingDetails(),
  //         ),
  //       ),
  //     );

  //     if (paymentMethod.id != null && paymentMethod.id!.isNotEmpty) {
  //       paymentMethodId.value = paymentMethod.id!;
  //       debugPrint("Payment Method ID: ${paymentMethodId.value}");
  //       // Don't set loading to false here, continue with payment flow
  //       await createSessionPayment();
  //     } else {
  //       // Set loading to false on error
  //       isStripeLoading.value = false;
  //       photoController.isLoading.value = false;
  //       throw Exception("Failed to generate Payment Method ID");
  //     }
  //   } catch (e) {
  //     isStripeLoading.value = false;
  //     photoController.isLoading.value = false;
  //     Get.snackbar(
  //       "Error",
  //       e.toString(),
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  // Future<void> createSessionPayment() async {
  //   try {
  //     final response = await photoCreationRepository.createPayment(
  //       paymentMethodId.value, 
  //       email.text.trim(),
  //       photoController.selectedPackage.value
        
  //     );
      
  //     response.fold(
  //       (error) {
  //         isStripeLoading.value = false;
  //         photoController.isLoading.value = false;
  //         Get.snackbar(
  //           "Error",
  //           error,
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white,
  //         );
  //       },
  //       (success) async {
  //         debugPrint("createPayment: success");
  //         var paymentIntentId = success;
  //         await confirmSessionPayment(paymentIntentId);
  //       },
  //     );
  //   } catch (e) {
  //     isStripeLoading.value = false;
  //     photoController.isLoading.value = false;
  //     Get.snackbar(
  //       "Error",
  //       "Payment creation failed: ${e.toString()}",
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  // Future<void> confirmSessionPayment(String paymentIntentId) async {
  //   try {
  //     final response = await photoCreationRepository.confirmPayment(
  //       paymentIntentId, 
  //       email.text.trim()
  //     );
      
  //     response.fold(
  //       (error) {
  //         isStripeLoading.value = false;
  //         photoController.isLoading.value = false;
  //         Get.snackbar(
  //           "Error",
  //           error,
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white,
  //         );
  //       },
  //       (success) async {
  //         // Get session ID from the PhotoController instead of storage
  //         final sessionId = photoController.sessionId.value;
          
  //         if (sessionId.isEmpty) {
  //           // Fallback to storage if sessionId is not available in controller
  //           final storageSessionId = appStorage.read("session_id");
  //           if (storageSessionId != null) {
  //             photoController.sessionId.value = storageSessionId;
  //           } else {
  //             isStripeLoading.value = false;
  //             photoController.isLoading.value = false;
  //             Get.snackbar(
  //               "Error", 
  //               "Session ID not found. Please try again.",
  //               backgroundColor: Colors.redAccent,
  //               colorText: Colors.white,
  //             );
  //             return;
  //           }
  //         }
          
  //         // Set Stripe loading to false, but keep photo controller loading true
  //         // as downloadImageById will manage its own loading state
  //         isStripeLoading.value = false;
          
  //         Get.snackbar(
  //           "Success", 
  //           "Payment confirmed successfully!",
  //           backgroundColor: Colors.green, 
  //           colorText: Colors.white
  //         );
          
  //         // This will handle its own loading state
  //         await photoController.downloadImageById(photoController.sessionId.value);
  //       },
  //     );
  //   } catch (e) {
  //     isStripeLoading.value = false;
  //     photoController.isLoading.value = false;
  //     Get.snackbar(
  //       "Error",
  //       "Payment confirmation failed: ${e.toString()}",
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  // Card API
  Future<void> onCreateCard() async {
    isCardLoading.value = true;
    try {
      // TODO: implement card creation logic
    } finally {
      isCardLoading.value = false;
    }
  }

  void resetCardField() {
    // cardEditController.clear();
  }
  
  @override
  void onClose() {
    email.dispose();
    // cardEditController.dispose();
    super.onClose();
  }
}