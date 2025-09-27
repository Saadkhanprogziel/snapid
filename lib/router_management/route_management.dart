import 'package:flutter/foundation.dart'; // Add this import for kIsWeb
import 'package:get/get.dart';
import 'package:snapid/bindings/bindings.dart';
import 'package:snapid/router_management/auth_middleware.dart';
import 'package:snapid/view/photo_session/drag_and_drop.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/view/assistant_fragment/assistant.dart';
import 'package:snapid/view/auth/forgot_password.dart';
import 'package:snapid/view/auth/login.dart';
import 'package:snapid/view/auth/otp.dart';
import 'package:snapid/view/auth/register.dart';
import 'package:snapid/view/auth/change_password.dart';
import 'package:snapid/view/auth/verify.dart';
import 'package:snapid/view/biometric/biometric.dart';
import 'package:snapid/view/profile_fragment/delete_account/delete_account.dart';
import 'package:snapid/view/profile_fragment/help_support/help_support.dart';
import 'package:snapid/view/history_fragment/history_fragment.dart';
import 'package:snapid/view/home/home.dart';
import 'package:snapid/view/notification/notification.dart';
import 'package:snapid/view/onboarding/onboarding.dart';
import 'package:snapid/view/onboarding/onboardingLastPage.dart';

import 'package:snapid/view/payment_method/payment_method.dart';
import 'package:snapid/view/photo_session/photo_session.dart';
import 'package:snapid/view/photo_session/photo_preview.dart';
import 'package:snapid/view/photo_session/photo_select/seletedPhotos.dart';
import 'package:snapid/view/popular_countries.dart/popular_countries.dart';
import 'package:snapid/view/profile_fragment/edit_profile/edit_profile.dart';
import 'package:snapid/view/profile_fragment/help_support/report_bug/report_bug.dart';
import 'package:snapid/view/profile_fragment/help_support/ticket_management/chat_screen/chat_screen.dart';
import 'package:snapid/view/profile_fragment/help_support/ticket_management/ticket_management.dart';
import 'package:snapid/view/security_setting/security_setting.dart';
import 'package:snapid/view/splash/splash.dart';

class Pages {
  static List<GetPage> getPages() {
    return [
      GetPage(
          name: PrimaryRoute.initialRoute,
          page: () => kIsWeb ? LoginScreen() : const SplashView(),
          binding: ControllerBindings()),
      GetPage(
        name: PrimaryRoute.onBoard,
        page: () => const OnBoardingView(),
        binding: ControllerBindings(),
        transition: Transition.leftToRightWithFade,
      ),
      GetPage(
        name: PrimaryRoute.onBoard3,
        page: () => OnboardingLastPage(),
        binding: ControllerBindings(),
        transition: Transition.cupertino,
      ),
      GetPage(
          name: PrimaryRoute.login,
          page: () => LoginScreen(),
          binding: ControllerBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.register,
          page: () => RegisterScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.verification,
          page: () => VerificationScreen(),
          binding: ControllerBindings(),
          transition: Transition.downToUp),
      GetPage(
          name: PrimaryRoute.otpScreen,
          page: () => OtpScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.forgotPassword,
          page: () => ForgotPassword(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.resetPassword,
          page: () => ChangePassword(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.home,
          middlewares: [AuthMiddleware()],
          page: () => HomeScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.photo_creation,
          page: () => PhotoSessionScreen(),
          binding: ControllerBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.notification,
          middlewares: [AuthMiddleware()],
          page: () => NotificationScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.history,
          page: () => HistoryFragment(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.securitySetting,
          middlewares: [AuthMiddleware()],
          page: () => SecuritySetting(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.biometric,
          page: () => Biometric(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.deleteAccount,
          page: () => DeleteAccount(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.help_support,
          page: () => HelpSupport(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.fadeIn),
      GetPage(
          name: PrimaryRoute.editProfile,
          page: () => EditProfile(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.downToUp),
      GetPage(
          name: PrimaryRoute.drag,
          page: () => const ImageDragAndDrop(),
          binding: ControllerBindings()),
      GetPage(
          name: PrimaryRoute.selectedPhoto,
          page: () => SelectedPhotosScreen(),
          binding: ControllerBindings(),
          transition: Transition.downToUp),
      GetPage(
          name: PrimaryRoute.assistant,
          page: () => AssistantFragment(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.popularCountires,
          page: () => PopularCountries(),
          binding: ControllerBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.payment_method,
          page: () => PaymentMethod(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.report_bug,
          page: () => ReportBug(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.photo_preview,
          page: () => PhotoPreview(),
          binding: ControllerBindings(),
          transition: Transition.downToUp),
      GetPage(
          name: PrimaryRoute.ticket_management,
          page: () => TicketManagement(),
          binding: ControllerBindings(),
          middlewares: [AuthMiddleware()],
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.chat_screen,
          page: () => ChatScreen(),
          middlewares: [AuthMiddleware()],
          binding: ControllerBindings(),
          transition: Transition.downToUp),
    ];
  }
}