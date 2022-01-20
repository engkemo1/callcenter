import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Appointments/AppointmentData.dart';
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableRes.dart';
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableResData.dart';
import 'package:e7gz_call_center/Model/Notification/AppointmentsReq.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConfirmCanceledController extends GetxController{
  String LOGD = '/ConfirmCanceledController';
  var myTokenKey,myIdKey;
  ModalHudController modalHudController = Get.put(ModalHudController());
  final getStorage = GetStorage();
  var dio = Dio();
  List<AppointmentData> allAppointmentData = List<AppointmentData>();
  var docId,date,notifyKey;


  ConfirmCanceledController(this.docId, this.date, this.notifyKey){
    myTokenKey = getStorage.read(ConstString.MyTokenKey);
    myIdKey = getStorage.read(ConstString.MyIdKey);
    update();
    print('$LOGD onInit:: $docId  ,  $date  ,  $notifyKey');
    AppointmentsReq req = AppointmentsReq(doctor_key: docId,date: date,callCenter_key: myIdKey,notify_key: notifyKey);
    getAppointmentToday(req);
  }


  Future<List<AppointmentTableResData>> getAppointmentToday(req) async {
    allAppointmentData.clear();
    modalHudController.changeisLoading(true);
    print('$LOGD :Request: ${jsonEncode(req)}');
    update();
    var Url = EndPoints.ConfirmDayCanceled +
        '?token='+myTokenKey;
    print('$LOGD :URL: $Url');

    var response;
    AppointmentTableRes docAppointmentTableRes;

    try {
      response = await dio.post(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
        data: jsonEncode(req),
      );
      docAppointmentTableRes = AppointmentTableRes.fromJson(response.data);
      print(
          '$LOGD docAppointmentTableRes:Json: ${docAppointmentTableRes.toJson()} -----> ${docAppointmentTableRes.data.length} ');
      if (docAppointmentTableRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<AppointmentTableResData> docAppointmentTableResData =
        List<AppointmentTableResData>.from(
            list.map((e) => AppointmentTableResData.fromJson(e)).toList());
        print('$LOGD appointmentData::: ${docAppointmentTableResData.length}');
        // this.appointmentData = docAppointmentTableResData.map((e) => AppointmentData(data: e)).toList();
        //   update();
        if(docAppointmentTableResData.length > 0){
          allAppointmentData = docAppointmentTableResData.map((e) => AppointmentData(data: e)).toList();
          print('Tharwatttt::filteredAppointmentData: ${allAppointmentData.length} ---> allAppointmentData ${allAppointmentData.length}');
          modalHudController.changeisLoading(false);
          update();
          return docAppointmentTableResData;
        }else{
          modalHudController.changeisLoading(false);
          print('$LOGD No Data000 :: ${docAppointmentTableRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoAppointment,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoAppointment),
          );
          return docAppointmentTableResData;
        }
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAppointment,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAppointment),
        );
        print('$LOGD No Data :: ${docAppointmentTableRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      docAppointmentTableRes = AppointmentTableRes.fromJson(e.response.data);
      this.allAppointmentData.clear();
      update();
      Get.snackbar(
        '', ConstString.NoAppointment,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAppointment),
      );
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
    }

  }

}