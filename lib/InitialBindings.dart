import 'package:get/get.dart';

import 'Controllers/CategoryController.dart';
import 'Controllers/DashbaordController.dart';
import 'Controllers/ItemCootroller.dart';
import 'Controllers/LoginController.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(DashBoardController());
    Get.put(CategoryController());
    Get.put(ItemController());
  }
}
