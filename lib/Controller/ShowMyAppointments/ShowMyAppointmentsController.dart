import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Appointments/AppointmentData.dart';
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableRes.dart';
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableResData.dart';
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
import 'package:intl/date_symbol_data_local.dart';

class ShowMyAppointmentsController extends GetxController{
  String LOGD = '/ShowMyAppointmentsController';
  DateTime now;
  DateFormat formatter;
  var currentDate,selectedWeekDay;
  String arabicDate;
  var selectedDay;
  var numOfDays;
  var myTokenKey,myIdKey;
  ModalHudController modalHudController = Get.put(ModalHudController());
  final getStorage = GetStorage();
  var dio = Dio();
  List<AppointmentData> allAppointmentData = List<AppointmentData>();
  List<AppointmentData> filteredAppointmentData = List<AppointmentData>();
  List<AvailableTimes> availableTimes = List<AvailableTimes>();
  TextEditingController search ;


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
    myIdKey = getStorage.read(ConstString.MyIdKey);
    getCurrentDate();
    update();
    super.onInit();
  }

  @override
  void onReady() async{
    await getAppointmentToday(currentDate);
  }

  Future<List<AppointmentTableResData>> getAppointmentToday(newDate) async {
    print('$LOGD :NewDate: $newDate');
    allAppointmentData.clear();
    filteredAppointmentData.clear();
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.ShowMyAppointments +
        '/'+newDate +
        '?token='+myTokenKey;
    print('$LOGD :URL: $Url');
    var response;
    AppointmentTableRes docAppointmentTableRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
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
          List<AppointmentData> appointmentResList = docAppointmentTableResData.map((e) => AppointmentData(data: e)).toList();
          appointmentResList.forEach((element) {
            if(element.statusKey !=3){
              allAppointmentData.add(element);
              filteredAppointmentData = allAppointmentData;
              update();
            }
          });
          print('Tharwatttt::filteredAppointmentData: ${filteredAppointmentData.length} ---> allAppointmentData ${allAppointmentData.length}');
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
      filteredAppointmentData.clear();
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

  Future<List<AvailableTimesPerDayData>>getAvailableTime(date) async{
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetAvailableTimes +
        '/'+date +
        '/'+myIdKey.toString()+
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
        dateSession: currentDate,time_key: selectedTimeKey,status_key: status_key);

    modalHudController.changeisLoading(true);
    update();
    Url = EndPoints.EditAppointment +'/'+appointmentId.toString() +'?token=' + myTokenKey;

    //TODO LOGS
    print('$LOGD docEditAppointment:URL: $Url');
    print('$LOGD docEditAppointment:Json: ${jsonEncode(docEditAppointmentReq)}');

/*    try {
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
        await getAppointmentToday(currentDate);
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
    }*/

  }


  void changeSelectedDay(var day,pickedDate) async {
    selectedDay = day;
    if(pickedDate == null){
      print('$LOGD :Before: $currentDate');
      currentDate = '${currentDate.toString().substring(0,4)}-${currentDate.toString().substring(5,7)}-$selectedDay';
      update();
      print('$LOGD :After: $currentDate');
      await getAppointmentToday(currentDate);
    }
  }

  getCurrentDate()async{
    now = DateTime.now();
    formatter = DateFormat('yyyy-MM-dd');
    // selectedWeekDay = getWeekDay(now.weekday);
    selectedDay = now.day;
    currentDate = formatter.format(now);
    numOfDays = daysInMonth(now);
    update();
    getArabicDate(now);

  }

  getArabicDate(date)async{
    await initializeDateFormatting("ar_SA", null);
    var formatter = DateFormat.yMMM('ar_SA');
    // print('$LOGD formatter.locale:: ${ formatter.locale} ');
    arabicDate = formatter.format(date);
    // print('$LOGD $arabicDate');
    update();
  }

  int daysInMonth(DateTime date){
    var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  Future<void> selectDate(context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));
    if (pickedDate != null){
      getArabicDate(pickedDate);
      changeSelectedDay(pickedDate.day,pickedDate);
      numOfDays = daysInMonth(pickedDate);
      currentDate = formatter.format(pickedDate);
      update();
      print('$LOGD selectDate: ${formatter.format(pickedDate)} ---> $currentDate');
      getAppointmentToday(formatter.format(pickedDate));
    }
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

  String convertTo12Hr(time){
    DateTime date = DateFormat("h:mm").parse(time); // think this will work better for you
    // print('$LOGD Time :: ${DateFormat('h:mm').format(date)} ---> $time');
    return DateFormat('h:mm a').format(date);
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

  void filterSearch(String query){
    // search = query as TextEditingController;
    // update();
    var dummySearchList = allAppointmentData;
    print('Tharwatttt::filterSearch0: ${query} ---> filterSearch ${search}');
    if(query.isNotEmpty){
      var dummyListData = List<AppointmentData>();
      dummySearchList.forEach((item) {
        // var course = FilteredDocResData.fromJson(item.);
        if(item.doctorName.toLowerCase().contains(query.toLowerCase()) ||
            item.patientName.toLowerCase().contains(query.toLowerCase()) ||
            item.patientPhone.toLowerCase().contains(query.toLowerCase())){
          dummyListData.add(item);
        }
      });
      filteredAppointmentData = [];
      filteredAppointmentData.addAll(dummyListData);
      print('Tharwatttt::filterSearch1: ${filteredAppointmentData.length} ---> filterSearch ${allAppointmentData.length}');
      update();
      return;
    }else{
      filteredAppointmentData = [];
      filteredAppointmentData = allAppointmentData;
      print('Tharwatttt::filterSearch2: ${filteredAppointmentData.length} ---> filterSearch ${allAppointmentData.length}');
    }
  }


}