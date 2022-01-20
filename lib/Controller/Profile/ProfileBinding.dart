import 'package:e7gz_call_center/Controller/Profile/ProfileController.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ProfileController(), permanent: true);
  }
}