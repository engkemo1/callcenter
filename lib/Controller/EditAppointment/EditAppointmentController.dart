import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Controller/ShowMyAppointments/ShowMyAppointmentsController.dart';
import 'package:e7gz_call_center/Model/Appointments/AppointmentData.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppintmentRes.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppointmentReq.dart';
import 'package:e7gz_call_center/Model/ShowAvailableTimes/AvailableTimesData.dart';
import 'package:e7gz_call_center/Model/ShowAvailableTimes/AvailableTimesPerDay.dart';
import 'package:e7gz_call_center/Model/ShowAvailableTimes/AvailableTimesPerDayData.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class EditAppointmentController extends GetxController{
  String LOGD = '/EditAppointmentController';
  AppointmentData _oldAppointmentData;
  var myTokenKey,myIdKey;
  ModalHudController modalHudController = Get.put(ModalHudController());
  ShowMyAppointmentsController _showMyAppointmentsController = Get.put(ShowMyAppointmentsController());
  final getStorage = GetStorage();
  var dio = Dio();
  DateFormat formatter;
  DateTime now;

  List<AvailableTimes> availableTimes = List<AvailableTimes>();


  var oldDate,oldSelectedWeekDay,oldStatus_key,oldPatientPhone,oldPatientName,oldAppointmentType,
      oldAppointmentTimeFrom,oldAppointmentTimeTo,oldDocKey;

  var selectedList ,selectedTimeKey;

  // var newDate,newSelectedWeekDay,newStatus_key,newPatientPhone,newPatientName,newAppointmentType,
  //     newAppointmentTimeFrom,newAppointmentTimeTo;


  EditAppointmentController(this._oldAppointmentData);

  @override
  void onInit() {
    myTokenKey = getStorage.read(ConstString.MyTokenKey);
    myIdKey = getStorage.read(ConstString.MyIdKey);
    now = DateTime.now();
    formatter = DateFormat('yyyy-MM-dd');
    update();

    super.onInit();
  }

/*
  getOldData(){
    oldDate = _oldAppointmentData.dateSession;
    getAvailableTime(oldDate);
    oldSelectedWeekDay =getWeekDay(DateTime.parse(oldDate).weekday);
    oldPatientName = _oldAppointmentData.patientName;
    oldPatientPhone = _oldAppointmentData.patientPhone;
    oldStatus_key = _oldAppointmentData.statusKey;
    oldAppointmentType = getAppointmentTypeFromStatusKey(oldStatus_key);
    getAppointmentTypeFromStatusKey(_oldAppointmentData.statusKey);
    oldAppointmentTimeFrom = convertTo12Hr(_oldAppointmentData.timeFrom.substring(0,5));
    oldAppointmentTimeTo = convertTo12Hr(_oldAppointmentData.timeTo.substring(0,5));
  }
*/

  Future<List<AvailableTimesPerDayData>>getAvailableTime(date,docKey) async{
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetAvailableTimes +
        '/'+date +
        '/'+docKey.toString()+
        '?token='+myTokenKey;
    print('$LOGD :URL: $Url');
    var response;
    print('');
    AvailableTimesPerDay docAvailableTimesPerDay;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );

      docAvailableTimesPerDay = AvailableTimesPerDay.fromJson(response.data);
      print(
          '$LOGD DocAvailableTimesPerDay:Json: ${docAvailableTimesPerDay.toJson()} -----> ${docAvailableTimesPerDay.data.length} ');
      if (docAvailableTimesPerDay.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<AvailableTimesPerDayData> docAvailableTimesPerDay =
        List<AvailableTimesPerDayData>.from(
            list.map((e) => AvailableTimesPerDayData.fromJson(e)).toList());
        print('$LOGD docAvailableTimesPerDay::: ${docAvailableTimesPerDay.length}');
        this.availableTimes = docAvailableTimesPerDay.map((e) => AvailableTimes(data: e)).toList();
        print('$LOGD availableTimes:Res:: ${availableTimes[0].timeStatus}');
        modalHudController.changeisLoading(false);
        update();
        return docAvailableTimesPerDay;
      }else {
        modalHudController.changeisLoading(false);
        Get.snackbar(
          '', ConstString.NoTimesForThisDate,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoTimesForThisDate),
        );
        print('$LOGD No Data :: ${docAvailableTimesPerDay.massage}');
        update();
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      this.availableTimes = null;
      update();
      Get.snackbar(
        '', ConstString.NoTimesForThisDate,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoTimesForThisDate),
      );
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
    }

  }

  Future<bool> docEditAppointment(appointmentId) async {
    var Url;
    var response;
    CreateAppointmentRes docEditAppointmentRes;
    CreateAppointmentReq docEditAppointmentReq;

    docEditAppointmentReq = CreateAppointmentReq(patientName: oldPatientName,patientPhone: oldPatientPhone,
        dateSession: oldDate,time_key: selectedTimeKey,status_key: oldStatus_key);

    modalHudController.changeisLoading(true);
    update();
    Url = EndPoints.EditAppointment +'/'+appointmentId.toString() +'?token=' + myTokenKey;

    //TODO LOGS
    print('$LOGD docEditAppointment:URL: $Url');
    print('$LOGD docEditAppointment:Json: ${jsonEncode(docEditAppointmentReq)}');

    try {
      response = await dio.put(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
        data: jsonEncode(docEditAppointmentReq),
      );
      docEditAppointmentRes = CreateAppointmentRes.fromJson(response.data);

      //TODO LOGS
      print(
          '$LOGD docEditAppointment:Json: ${docEditAppointmentRes.toJson()} -----> ${docEditAppointmentRes.data.dateSession} ');
      print('$LOGD No Data :: ${docEditAppointmentRes.status}');

      if (docEditAppointmentRes.status ) {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
            '', ConstString.AppointmentUpdate,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround);

        //TODO Important To Refresh The DocAAppTable
        _showMyAppointmentsController.changeSelectedDay(DateTime.parse(oldDate).day,DateTime.parse(oldDate));
        await _showMyAppointmentsController.getAppointmentToday(oldDate);
        Get.back();
        return true;
      }else {
        modalHudController.changeisLoading(false);
        print('$LOGD No Data :: ${docEditAppointmentRes.massage}');
        update();
        Get.snackbar(
            ConstString.ErrorOccurred, validateCreateAppointmentError(docEditAppointmentRes.massage[0]),
            backgroundColor: Colors.red[600],
            colorText: ConstStyles.BaseBackGround);
        return false;
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      docEditAppointmentRes = CreateAppointmentRes.fromJson(e.response.data);
      update();
      print('$LOGD docEditAppointment:Catch: ${jsonEncode(e.response.data)}  ---->>>> ${e.response.statusMessage}');
      // print('$LOGD catch:2: ${docCreateAppointmentRes.massage} }');
      if(docEditAppointmentRes.massage.length>1){
        Get.snackbar(
            ConstString.ErrorOccurred, ConstString.AllDataRequired,
            backgroundColor: Colors.red[600],
            colorText: ConstStyles.BaseBackGround);
      }else{
        Get.snackbar(
            ConstString.ErrorOccurred, validateCreateAppointmentError(docEditAppointmentRes.massage[0]),
            backgroundColor: Colors.red[600],
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
      case 'This time are booked':
        return 'هذا التوقيت محجوز من فضلك اختار توقيت أخر';
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

  String getAppointmentTypeFromStatusKey(key){
    switch(key){
      case 1 :
        {
          oldAppointmentType = ConstString.New;
          update();
          print('$LOGD getoldAppointmentTypeFromStatusKey :: $oldAppointmentType');
          return oldAppointmentType;
        }
      case 2 :
        {
          oldAppointmentType = ConstString.Consultation;
          update();
          print('$LOGD getoldAppointmentTypeFromStatusKey :: $oldAppointmentType');
          return oldAppointmentType;
        }
      case 3 :
        {
          oldAppointmentType = ConstString.Cancel;
          update();
          print('$LOGD getoldAppointmentTypeFromStatusKey :: $oldAppointmentType');
          return oldAppointmentType;
        }
      case 4 :
        {
          oldAppointmentType = ConstString.Finish;
          update();
          print('$LOGD getoldAppointmentTypeFromStatusKey :: $oldAppointmentType');
          return oldAppointmentType;
        }
    }
  }

  String convertTo12Hr(time){
    DateTime date = DateFormat("h:mm").parse(time); // think this will work better for you
    // print('$LOGD Time :: ${DateFormat('h:mm').format(date)} ---> $time');
    return DateFormat('h:mm a').format(date);
  }

  Future<void> selectDate(context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(oldDate),
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));
    if (pickedDate != null){
      oldSelectedWeekDay =  getWeekDay(pickedDate.weekday);
      oldDate = formatter.format(pickedDate);
      update();
      getAvailableTime(formatter.format(pickedDate),oldDocKey);
    }
    /*else{
      oldSelectedWeekDay =  getWeekDay(now.weekday);
      oldDate = formatter.format(now);
      update();
    }*/
  }

  changeAppointmentType(newValue){
    oldAppointmentType = newValue;
    update();
    print('$LOGD changeAppointmentType :: $newValue');
    if(newValue == ConstString.New){
      oldStatus_key = 1;
      update();
    }else if(newValue == ConstString.Consultation){
      oldStatus_key = 2;
      update();
    }else if(newValue == ConstString.Cancel){
      oldStatus_key = 3 ;
      update();
    }else if(newValue == ConstString.Finish){
      oldStatus_key = 4;
      update();
    }
    print('$LOGD changeAppointmentType :: $oldStatus_key');
  }

  changeSelectedList(index){
    selectedList = index;
    update();
  }

  changeSelectedTimeKey(timeKey){
    selectedTimeKey = timeKey;
    update();
  }



}