import 'package:app/controllers/auth_module/auth_controller.dart';
import 'package:app/controllers/base_module/local_storage_data.dart';
import 'package:app/controllers/home_module/home_page.dart';
import 'package:get/get.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocalStorageData());
    Get.put(() => HomePageController());

    Get.put(AuthController());
  }
}
