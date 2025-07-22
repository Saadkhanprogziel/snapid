import 'package:get/get.dart';
import 'package:snapid/bindings/bindings.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/view/auth/forgot_password.dart';
import 'package:snapid/view/auth/login.dart';
import 'package:snapid/view/auth/otp.dart';
import 'package:snapid/view/auth/register.dart';
import 'package:snapid/view/auth/reset_password.dart';
import 'package:snapid/view/auth/verify.dart';
import 'package:snapid/view/home/home.dart';
import 'package:snapid/view/notification/notification.dart';
import 'package:snapid/view/onboarding/onboarding.dart';
import 'package:snapid/view/onboarding/onboarding2.dart';
import 'package:snapid/view/splash/splash.dart';

class Pages {
  static List<GetPage> getPages() {
    return [
      GetPage(
          name: PrimaryRoute.splash,
          page: () => const SplashView(),
          binding: ControllerBindings()),
      GetPage(
        name: PrimaryRoute.onBoard,
        page: () => const OnBoardingView(),
        binding: ControllerBindings(),
        transition: Transition.leftToRightWithFade,
      ),
      GetPage(
        name: PrimaryRoute.onBoard3,
        page: () => const Onboarding3(),
        binding: ControllerBindings(),
        transition: Transition.cupertino,
      ),
      GetPage( 
          name: PrimaryRoute.login,
          page: () => const LoginScreen(),
          binding: ControllerBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: PrimaryRoute.register,
          page: () => const RegisterScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn
          )
          
          ,
      GetPage(
          name: PrimaryRoute.verification,
          page: () =>  VerificationScreen(),
          binding: ControllerBindings(),
          transition: Transition.downToUp
          ),
          
      GetPage(
          name: PrimaryRoute.otpScreen,
          page: () =>  OtpScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn
          ),
      GetPage(
          name: PrimaryRoute.forgotPassword,
          page: () =>  ForgotPassword(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn
          ),
      GetPage(
          name: PrimaryRoute.resetPassword,
          page: () =>  ResetPassowrd(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn
          ),
      GetPage(
          name: PrimaryRoute.home,
          page: () =>  HomeScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn
          ),
      GetPage(
          name: PrimaryRoute.notification,
          page: () =>  NotificationScreen(),
          binding: ControllerBindings(),
          transition: Transition.fadeIn
          ),
    ];
  }
}
