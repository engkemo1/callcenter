import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsController.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Controller/ShowMyAppointments/ShowMyAppointmentsController.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppintmentRes.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppointmentReq.dart';
import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocReq.dart';
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

class CreateDetailsAppointmentController extends GetxController{
  String LOGD = '/CreateDetailsAppointmentController';
  final ModalHudController modalHudController = Get.put(ModalHudController());
  AllDoctorsController _allDoctorsController = Get.put(AllDoctorsController());
  ShowMyAppointmentsController _showMyAppointmentsController = Get.put(ShowMyAppointmentsController());
  var myTokenKey;
  final getStorage = GetStorage();
  var dio = Dio();
  DateFormat formatter;
  DateTime now;
  var currentDate;
  var selectedWeekDay;

  //TODO Patient Data For Api Request
  String patientName;
  String patientPhone;
  String appointmentType;
  var dateSession;
  int selectedTimeKey;
  int status_key;

  var docKey;

  List<AvailableTimes> availableTimes = List<AvailableTimes>();
  var selectedList ;


  CreateDetailsAppointmentController(this.docKey);

  @override
  void onInit() {
    myTokenKey = getStorage.read(ConstString.MyTokenKey);
    update();
      print('$LOGD Doctor Key = $docKey');
    super.onInit();
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
        dateSession = null ;
        update();
        _allDoctorsController.getAllDoc(FilteredDocReq(date: currentDate)).then((value) {
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
      createAppointmentRes = CreateAppointmentRes.fromJson(e.response.data);
      update();
      print('$LOGD catch:1: ${jsonEncode(e.response.statusMessage)}  ---->>>> ${createAppointmentRes.massage}');
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

  Future<List<AvailableTimesPerDayData>>getAvailableTime(date) async{
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

    docEditAppointmentReq = CreateAppointmentReq(patientName: patientName,patientPhone: patientPhone,
        dateSession: dateSession,time_key: selectedTimeKey,status_key: status_key);

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
        await _showMyAppointmentsController.getAppointmentToday(dateSession);
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

  getCurrentDate()async{
    now = DateTime.now();
    formatter = DateFormat('yyyy-MM-dd');
    currentDate = formatter.format(now);
    selectedWeekDay = getWeekDay(now.weekday);
    update();
    getAvailableTime(currentDate);
  }

  String getAppointmentTypeFromStatusKey(key){
    switch(key){
      case 1 :
        {
          appointmentType = ConstString.New;
          update();
          print('$LOGD getAppointmentTypeFromStatusKey :: $appointmentType');
          return appointmentType;
        }
      case 2 :
        {
          appointmentType = ConstString.Consultation;
          update();
          print('$LOGD getAppointmentTypeFromStatusKey :: $appointmentType');
          return appointmentType;
        }
      case 3 :
        {
          appointmentType = ConstString.Cancel;
          update();
          print('$LOGD getAppointmentTypeFromStatusKey :: $appointmentType');
          return appointmentType;
        }
      case 4 :
        {
          appointmentType = ConstString.Finish;
          update();
          print('$LOGD getAppointmentTypeFromStatusKey :: $appointmentType');
          return appointmentType;
        }
    }
  }

  String convertTo12Hr(time){
    DateTime date = DateFormat("h:mm").parse(time); // think this will work better for you
    // print('$LOGD Time :: ${DateFormat('h:mm').format(date)} ---> $time');
    return DateFormat('h:mm a').format(date);
  }

  //TODo Form Date_Util
  Future<void> selectDate(context) async {
    await getCurrentDate();
    final DateTime pickedDate = await showDatePicker(
      // locale: const Locale('ar','EG'),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));
    if (pickedDate != null){
      // print('$LOGD dateForAvailableTimes:: ${pickedDate.weekday}');
      selectedWeekDay =  getWeekDay(pickedDate.weekday);
      dateSession = formatter.format(pickedDate);
      update();
      getAvailableTime(formatter.format(pickedDate));
    }else{
      selectedWeekDay =  getWeekDay(now.weekday);
      dateSession = formatter.format(now);
      update();
    }
    // print('$LOGD dateForAvailableTimes:: $dateSession');
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

  changeSelectedList(index){
    selectedList = index;
    update();
  }

  changeSelectedTimeKey(timeKey){
    selectedTimeKey = timeKey;
    update();
  }



}