
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Appointments/AppointmentData.dart';
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableRes.dart';
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableResData.dart';
import 'package:e7gz_call_center/Model/Notification/AllNotificationList.dart';
import 'package:e7gz_call_center/Model/Notification/AllNotificationRes.dart';
import 'package:e7gz_call_center/Model/Notification/AllNotificationResData.dart';
import 'package:e7gz_call_center/Model/Notification/AppointmentsReq.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShowAllNotificationController extends GetxController{
  String LOGD = '/ShowAllNotificationController';
  final ModalHudController modalHudController = Get.put(ModalHudController());
  var dio = Dio();
  final getStorage = GetStorage();
  static var myTokenKey, myIdKey;
  List<AllNotificationList> allNotificationList = List<AllNotificationList>();
  List<AllNotificationList> allNotificationReversedList = List<AllNotificationList>();

  @override
  void onInit() async{
    myTokenKey =getStorage.read(ConstString.MyTokenKey);
    myIdKey =  getStorage.read(ConstString.MyIdKey);
    // initPusher();
    getAllNotification();
    update();
    super.onInit();
  }


  Future<List<AllNotificationResData>> getAllNotification() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.AllNotification+'?token=' + myTokenKey;
    print('$LOGD getAllNotification:URL: $Url');
    var response;
    AllNotificationRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = AllNotificationRes.fromJson(response.data);
      print(
          '$LOGD getAllNotification:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<AllNotificationResData> specialistResData =
        List<AllNotificationResData>.from(
            list.map((e) => AllNotificationResData.fromJson(e)).toList());
        print('$LOGD getAllNotification::: ${specialistResData.length}');
        if(specialistResData.length > 0){
          this.allNotificationList = specialistResData.map((e) => AllNotificationList(data: e)).toList();
          allNotificationReversedList = allNotificationList.reversed.toList();
          print('$LOGD getAllNotification::: ${allNotificationList[0].notifyMessage}');
          modalHudController.changeisLoading(false);
          update();
          return specialistResData;
        }else{
          modalHudController.changeisLoading(false);
          print('$LOGD getAllNotification Data000 :: ${specialistRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoNotification,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoNotification),
          );
          return specialistResData;
        }
      }
      else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoNotification,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoNotification),
        );
        print('$LOGD No Data :getAllNotification: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = AllNotificationRes.fromJson(e.response.data);
      this.allNotificationList = null;
      update();
      Get.snackbar(
        '', ConstString.NoNotification,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoNotification),
      );
    }
  }



}