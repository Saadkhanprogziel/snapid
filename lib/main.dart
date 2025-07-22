import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/router_management/route_management.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_scroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: Strings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
        ),
        primaryColorLight: AppColors.lightBlue,
      ),
      builder: (context, widget) {
        return ResponsiveWrapper.builder(
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1),
            ),
            child: BouncingScrollWrapperX.builder(
              context,
              widget!,
              dragWithMouse: false,
            ),
          ),
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.autoScaleDown(450, name: MOBILE),
            ResponsiveBreakpoint.autoScaleDown(800, name: TABLET),
            ResponsiveBreakpoint.autoScaleDown(1920, name: DESKTOP),
          ],
        );
      },
      initialRoute: PrimaryRoute.splash,
      getPages: Pages.getPages(),
      smartManagement: SmartManagement.full,
    );
  }
}


