import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';

import '../Controllers/DashbaordController.dart';
import '../Services/ConnectivityService.dart';

class DashboardPage extends StatelessWidget {
  final icons = [
    Icons.home_outlined,
    Icons.category_outlined,
    Icons.history_outlined,
    Icons.account_circle_outlined
  ];
  final DashBoardController dashboardController = Get.find();
  static final GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    checkconnection();
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber[900],
          onPressed: () {
            dashboardController.pageindex.value = 0;
          },
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Obx(() => AnimatedBottomNavigationBar(
            key: _bottomNavigationKey,
            icons: icons,
            activeIndex: dashboardController.pageindex.value,
            activeColor: Colors.white,
            elevation: 9,
            height: 75,
            backgroundColor: Colors.amber,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            onTap: (index) => dashboardController.pageindex.value = index)),
        body: Obx(() =>
            dashboardController.pages[dashboardController.pageindex.value]));
  }
}
