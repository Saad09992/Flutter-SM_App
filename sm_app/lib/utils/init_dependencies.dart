import 'package:sm_app/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:sm_app/controller/user_controller.dart';

class InitDependencies extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => UserController());
  }
}
