
import 'package:e7gz_call_center/Controller/ShowMyAppointments/ShowMyAppointmentsController.dart';
import 'package:get/get.dart';

class ShowMyAppointmentsBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ShowMyAppointmentsController(), permanent: true);
  }
}