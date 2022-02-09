import 'package:get/get.dart';

import '../Pages/Dashboard%20Screens/DashboardCategory&Items.dart';
import '../Pages/Dashboard%20Screens/DashboardHome.dart';
import '../Pages/Dashboard%20Screens/DashboardOrderHistory.dart';
import '../Pages/Dashboard%20Screens/DashboardProfile.dart';

class DashBoardController extends GetxController {
  final pageindex = 0.obs;
  final pages = [
    DashboardHome(),
    Categories(),
    DashboardOrderHistory(),
    DashbaordProfile(),
  ];
}
