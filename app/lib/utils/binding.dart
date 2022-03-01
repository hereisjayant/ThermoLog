import 'package:app/controllers/auth_module/auth_controller.dart';
import 'package:app/controllers/base_module/bottom_bar_controller.dart';
import 'package:app/controllers/base_module/local_storage_data.dart';
import 'package:app/controllers/profile_module/profile_page.dart';
import 'package:get/get.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocalStorageData());
    Get.put(() => BottomBarController());
    Get.lazyPut(() => ProfilePageController());

    Get.put(AuthController());
  }
}
