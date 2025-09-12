import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/router_management/route_management.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_scroll.dart';

final appStorage = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // required!
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
            ResponsiveBreakpoint.autoScale(600, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(1400, name: DESKTOP),
          ], 
        );
      },
      initialRoute: PrimaryRoute.splash,
      getPages: Pages.getPages(),
      smartManagement: SmartManagement.full,
    );
  }
}
