
import 'package:e7gz_call_center/Controller/Chats/ChatsController.dart';
import 'package:get/get.dart';

class ChatsBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ChatsController(), permanent: true);
  }
}