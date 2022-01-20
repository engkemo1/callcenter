import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsController.dart';
import 'package:get/get.dart';

class AllDoctorsBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AllDoctorsController(), permanent: true);
  }
}