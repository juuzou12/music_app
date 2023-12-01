import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller/dashboardcontroller.dart';
import 'controller/splashscreencontroller.dart';
import 'pages/splashscreen.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    Get.put(DashboardController());
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: () {
        return GetMaterialApp(
          title: 'SonicBlend',
          home: SplashScreenView(),
        );
      },
    );
  }
}
