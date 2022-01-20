import 'package:e7gz_call_center/Controller/Auth/LoginController.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController(), permanent: true);
  }
}