import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'InitialBindings.dart';
import 'Pages/DashboardPage.dart';
import 'Pages/HomePage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/PinsPage.dart';
import 'Pages/RegisterResturantInfo.dart';
import 'Pages/SplashScreen.dart';
import 'Pages/UnknowPage.dart';
import 'Services/ConnectivityService.dart';

class FooduRestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.light().copyWith(primaryColor: Colors.amber),
      // darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.blueAccent),
      //themeMode: ThemeMode.system,
      builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child),
          defaultScale: true,
          minWidth: 480,
          defaultName: DESKTOP,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(480, name: MOBILE),
            ResponsiveBreakpoint.resize(600, name: MOBILE),
            ResponsiveBreakpoint.resize(850, name: TABLET),
            ResponsiveBreakpoint.resize(1080, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(
            height: Get.height,
            width: Get.width,
            color: Colors.white24,
          )),
      getPages: [
        GetPage(name: "/", page: () => HomePage(), transition: Transition.zoom),
        GetPage(
            name: "/login",
            page: () => LoginScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: "/dashboard",
            page: () => DashboardPage(),
            transition: Transition.topLevel),
        GetPage(
            name: "/registerinfo",
            page: () => RegisterRestaurantInfo(),
            transition: Transition.downToUp),
        GetPage(name: "/splash", page: () => SplashScreen()),
        GetPage(name: "/pins", page: () => PinsPage()),
      ],
      initialRoute: "/splash",
      unknownRoute: GetPage(name: "/unknow", page: () => UnknownPage()),
      initialBinding: InitialBindings(),
      onReady: () => checkconnection(),
    );
  }
}
