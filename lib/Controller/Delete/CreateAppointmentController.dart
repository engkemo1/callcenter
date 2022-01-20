/*

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/AllDoctorsController.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppintmentRes.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppointmentReq.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class CreateAppointmentController extends GetxController{
  String LOGD = '//CreateAppointmentController';
  final ModalHudController modalHudController = Get.put(ModalHudController());
  AllDoctorsController _allDoctorsController = Get.put(AllDoctorsController());
  var myTokenKey;
  final getStorage = GetStorage();
  var dio = Dio();
  DateTime now;
  DateFormat formatter;

  var selectedWeekDay;
  var currentDate;

  //TODO Patient Data For Api Request
  String patientName;
  String patientPhone;
  String appointmentType;
  var dateSession;
  int selectedTimeKey;
  int status_key;


  @override
  void onInit() {
    myTokenKey = getStorage.read(ConstString.MyTokenKey);
    getCurrentDate();
    update();

    super.onInit();
  }

  changeAppointmentType(newValue){
    appointmentType = newValue;
    update();
    print('$LOGD changeAppointmentType :: $newValue');
    if(newValue == ConstString.New){
      status_key = 1;
      update();
    }else if(newValue == ConstString.Consultation){
      status_key = 2;
      update();
    }else if(newValue == ConstString.Cancel){
      status_key = 3 ;
      update();
    }else if(newValue == ConstString.Finish){
      status_key = 4;
      update();
    }
    print('$LOGD changeAppointmentType :: $status_key');
  }

  Future<bool> createAppointment(CreateAppointmentReq req) async {
    var Url;
    var response;
    CreateAppointmentRes createAppointmentRes;
    // CreateAppointmentReq createAppointmentReq;

    // createAppointmentReq = CreateAppointmentReq(patientName: patientName,patientPhone: patientPhone,
    //     dateSession: dateSession,time_key: selectedTimeKey,status_key: status_key);
    modalHudController.changeisLoading(true);
    update();
    Url = EndPoints.CreateNewAppointment + myTokenKey;

    //TODO LOGS
    print('$LOGD createAppointmentRes:URL: $Url');
    print('$LOGD createAppointmentReq:Json: ${jsonEncode(req)}');

    try {
      response = await dio.post(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
        data: jsonEncode(req),
      );
      createAppointmentRes = CreateAppointmentRes.fromJson(response.data);

      //TODO LOGS
      print(
          '$LOGD createAppointmentRes:Json: ${createAppointmentRes.toJson()} -----> ${createAppointmentRes.data.dateSession} ');

      if (createAppointmentRes.status ) {
        print('$LOGD Status:: ${createAppointmentRes.status}');
        modalHudController.changeisLoading(false);
        Get.snackbar(
            '', ConstString.AppointmentCreated,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround);
        Get.back();
        update();
        _allDoctorsController.getAllDoc(null).then((value) {
          _allDoctorsController.allFilteredDocList = value;
          _allDoctorsController.filteredDocList = _allDoctorsController.allFilteredDocList;
          update();
        });
        return true;
      }else {
        modalHudController.changeisLoading(false);
        print('$LOGD No Data :: ${createAppointmentRes.massage}');
        update();
        Get.snackbar(
            ConstString.ErrorOccurred, validateCreateAppointmentError(createAppointmentRes.massage[0]),
            backgroundColor: ConstStyles.TimeStatusUnAvailable,
            colorText: ConstStyles.BaseBackGround);
        return false;
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      // createAppointmentRes = CreateAppointmentRes.fromJson(e.response.data);
      update();
      print('$LOGD catch:1: ${jsonEncode(e.response.statusMessage)}  ---->>>> ${e.response.statusMessage}');
      // print('$LOGD catch:2: ${docCreateAppointmentRes.massage} }');
      if(e.response.statusMessage == 'Not Found'){
        Get.snackbar(
            ConstString.ErrorOccurred, ConstString.AllDataRequired,
            backgroundColor: ConstStyles.TimeStatusUnAvailable,
            colorText: ConstStyles.BaseBackGround);
      }else{
        Get.snackbar(
            ConstString.ErrorOccurred, validateCreateAppointmentError(createAppointmentRes.massage[0]),
            backgroundColor: ConstStyles.TimeStatusUnAvailable,
            colorText: ConstStyles.BaseBackGround);
      }
      return false;
    }

  }

  String validateCreateAppointmentError(msg){
    switch(msg){
      case 'The patient name field is required.':
        return 'إسم المريض مطلوب';
      case 'The patient phone field is required.':
        return 'برجاء إدخال رقم الهاتف';
      case 'The patient phone must be at least 9 characters.':
        return 'رقم الهاتف غير صحيح';
      case 'The time key field is required.':
        return 'برجاء إختيار توقيت الحجز';
      case 'The date session field is required.':
        return 'برجاء إختيار تاريخ الحجز';
      case 'Unauthenticated. Doctor role required':
        return 'حدث خطاء ما برجاء المحاولة';
    }
  }

  String getWeekDay(int day) {
    switch (day) {
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      case 1:
        return 'الأثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
    }
  }

  getCurrentDate()async{
    now = DateTime.now();
    formatter = DateFormat('yyyy-MM-dd');
    currentDate = formatter.format(now);
    selectedWeekDay = getWeekDay(now.weekday);
    update();
  }
}*/
