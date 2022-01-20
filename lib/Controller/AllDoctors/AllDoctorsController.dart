import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Chat/ChatPusherNotifyRes.dart';
import 'package:e7gz_call_center/Model/ChatMessagePusherRes.dart';
import 'package:e7gz_call_center/Model/City/CityList.dart';
import 'package:e7gz_call_center/Model/City/CityRes.dart';
import 'package:e7gz_call_center/Model/City/CityResData.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppintmentRes.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppointmentReq.dart';
import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocList.dart';
import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocReq.dart';
import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocRes.dart';
import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocResData.dart';
import 'package:e7gz_call_center/Model/Government/GovernmentList.dart';
import 'package:e7gz_call_center/Model/Government/GovernmentRes.dart';
import 'package:e7gz_call_center/Model/Government/GovernmentResDat.dart';
import 'package:e7gz_call_center/Model/Logout/LogoutDocRes.dart';
import 'package:e7gz_call_center/Model/Notification/PusherNotificationRes.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileRes.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileResData.dart';
import 'package:e7gz_call_center/Model/SearchDoc/SearchDocList.dart';
import 'package:e7gz_call_center/Model/SearchDoc/SearchDocRes.dart';
import 'package:e7gz_call_center/Model/SearchDoc/SearchDocResData.dart';
import 'package:e7gz_call_center/Model/Specialist/SpecialistList.dart';
import 'package:e7gz_call_center/Model/Specialist/SpecialistRes.dart';
import 'package:e7gz_call_center/Model/Specialist/SpecialistResData.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/Auth/Login.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pusher_websocket_flutter/pusher.dart';

class AllDoctorsController extends GetxController{
  String LOGD = '//AllDoctorsController';
  final ModalHudController modalHudController = Get.put(ModalHudController());
  var dio = Dio();
  final getStorage = GetStorage();
  var myTokenKey, myIdKey;
  List<SpecialistList> specialistDataList = List<SpecialistList>();
  List<GovernmentList> governmentDataList = List<GovernmentList>();
  List<CityList> citiesDataList = List<CityList>();

  List<FilteredDocList> allFilteredDocList = List<FilteredDocList>();
  List<FilteredDocList> filteredDocList = List<FilteredDocList>();
  List<SearchDocList> allSearchedDocList = List<SearchDocList>();

  DateTime now;
  DateFormat formatter;
  var currentDate,selectedWeekDay;
  var docSearchName;

  TextEditingController searchDoc ;
  String selectedDep,selectedGov,selectedCity;

  //TODO Patient Data For Api Request
  String patientName;
  String patientPhone;
  String appointmentType;
  int status_key; // Appointment Type

  //TODO Notification
  StreamController<PusherNotificationRes> _eventData = StreamController<PusherNotificationRes>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;
  Channel channel;
  String channelName = 'NotifyCallcenter';
  String eventName = 'NotifyCallcenter';
  List<PusherNotificationRes> notificationPusherList = List<PusherNotificationRes>().obs;

  //TODO Chat Notify
  StreamController<ChatPusherNotifyRes> _chatEventData = StreamController<ChatPusherNotifyRes>();
  Sink get _inChatEventData => _chatEventData.sink;
  Stream get chatEventStream => _chatEventData.stream;
  Channel chatChannel;
  String chatChannelName = 'supportChat';
  String chatEventName = 'supportChat';
  List<ChatPusherNotifyRes> chatPusherList = new List<ChatPusherNotifyRes>().obs;

  //TODO Chat Message
  StreamController<ChatMessagePusherRes> _chatMessageEventData = StreamController<ChatMessagePusherRes>();
  Sink get _inChatMessageEventData => _chatMessageEventData.sink;
  Stream get chatMessageEventStream => _chatMessageEventData.stream;
  Channel chatMessageChannel;
  String chatMessageChannelName = 'chatMessage';
  String chatMessageEventName = 'chatMessage';
  List<ChatMessagePusherRes> chatMessagePusherList = new List<ChatMessagePusherRes>().obs;

  //TODO Profile
  ProfileResData infoResData = ProfileResData();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //TODO background

  @override
  void onInit() async{
    myTokenKey =getStorage.read(ConstString.MyTokenKey);
    myIdKey =  getStorage.read(ConstString.MyIdKey);
    getCurrentDate();
     await notify2();
     notifyCancelPusher();
     chatPusher();
     chatMessagePusher();
    update();
    super.onInit();
  }

  @override
  void onReady() async{
    await getProfileData();
    await getAllGovernment();
    await getAllSpecialist();
    await getAllDoc(null).then((value)  {
      allFilteredDocList = value;
      filteredDocList = allFilteredDocList;
      update();
    });

  }

  Future<List<SpecialistResData>> getAllSpecialist() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetAllSpecialist + myTokenKey;
    // print('$LOGD :URL: $Url');
    var response;
    SpecialistRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = SpecialistRes.fromJson(response.data);
      // print(
      //     '$LOGD specialistRes:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<SpecialistResData> specialistResData =
        List<SpecialistResData>.from(
            list.map((e) => SpecialistResData.fromJson(e)).toList());
        // print('$LOGD appointmentData::: ${specialistResData.length}');
        // this.appointmentData = docAppointmentTableResData.map((e) => AppointmentData(data: e)).toList();
        if(specialistResData.length > 0){
          this.specialistDataList = specialistResData.map((e) => SpecialistList(data: e)).toList();
          // print('$LOGD specialistDataList::: ${specialistDataList[0]}');
          modalHudController.changeisLoading(false);
          // var list = [ConstString.ChooseDepartment,];
          // selectedDep = list[0];
          // selectedDep = specialistDataList[0].name;
          update();
          return specialistResData;
        }else{
          modalHudController.changeisLoading(false);
          // print('$LOGD No Data000 :: ${specialistRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoAvailableDoctors,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
          );
          return specialistResData;
        }
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAvailableDoctors,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
        );
        // print('$LOGD No Data :: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = SpecialistRes.fromJson(response.data);
      this.specialistDataList = null;
      update();
      Get.snackbar(
        '', ConstString.NoAvailableDoctors,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
      );
      // print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
      // print('$LOGD catch:2: ${docAppointmentTableRes.massage.toString()} }');
      // Get.snackbar(
      //     ConstString.ErrorOccurred, errorVaild(registerDocRes.massage[0]),
      //     backgroundColor: Colors.red[600],
      //     colorText: ConstStyles.BaseBackGround);
      // return docAppointmentTableResData;
    }
  }

  Future<List<GovernmentResData>> getAllGovernment() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetAllGovernment +myTokenKey ;
    // print('$LOGD :URL: ${EndPoints.GetAllGovernment +myTokenKey}');
    var response;
    GovernmentRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = GovernmentRes.fromJson(response.data);
      // print(
      //     '$LOGD specialistRes:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<GovernmentResData> specialistResData =
        List<GovernmentResData>.from(
            list.map((e) => GovernmentResData.fromJson(e)).toList());
        // print('$LOGD appointmentData::: ${specialistResData.length}');
        // this.appointmentData = docAppointmentTableResData.map((e) => AppointmentData(data: e)).toList();
        if(specialistResData.length > 0){
          this.governmentDataList = specialistResData.map((e) => GovernmentList(data: e)).toList();
          // print('$LOGD specialistDataList::: ${specialistDataList[0]}');
          modalHudController.changeisLoading(false);
          update();
          return specialistResData;
        }else{
          modalHudController.changeisLoading(false);
          // print('$LOGD No Data000 :: ${specialistRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoAvailableDoctors,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
          );
          return specialistResData;
        }
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAvailableDoctors,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
        );
        // print('$LOGD No Data :: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = GovernmentRes.fromJson(response.data);
      this.governmentDataList = null;
      update();
      Get.snackbar(
        '', ConstString.NoAvailableDoctors,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
      );
    }
  }

  Future<List<CityResData>> getAllCities(govId) async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetCitiesByGov+'/' + govId.toString();
    // print('$LOGD getAllCities:URL: $Url');
    var response;
    CityRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = CityRes.fromJson(response.data);
      // print(
      //     '$LOGD getAllCities:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<CityResData> specialistResData =
        List<CityResData>.from(
            list.map((e) => CityResData.fromJson(e)).toList());
        // print('$LOGD getAllCities::: ${specialistResData.length}');
        // this.appointmentData = docAppointmentTableResData.map((e) => AppointmentData(data: e)).toList();
        if(specialistResData.length > 0){
          this.citiesDataList = specialistResData.map((e) => CityList(data: e)).toList();
          // print('$LOGD getAllCities::: ${specialistDataList[0]}');
          modalHudController.changeisLoading(false);
          update();
          return specialistResData;
        }else{
          modalHudController.changeisLoading(false);
          // print('$LOGD getAllCities Data000 :: ${specialistRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoAvailableDoctors,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
          );
          return specialistResData;
        }
      }
      else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAvailableDoctors,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
        );
        // print('$LOGD No Data :: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = CityRes.fromJson(response.data);
      this.citiesDataList = null;
      update();
      Get.snackbar(
        '', ConstString.NoAvailableDoctors,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
      );
    }
  }

  Future<List<FilteredDocList>> getAllDoc(FilteredDocReq req) async {
    // allFilteredDocList = List<FilteredDocList>();
    // filteredDocList = List<FilteredDocList>();
    // allSearchedDocList = List<SearchDocList>();
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetFilteredDoc + myTokenKey;
    print('$LOGD :URL getAllDoc: $Url');
    print('$LOGD :Req getAllDoc: ${jsonEncode(req)}');

    var response;
    FilteredDocRes filteredDocRes;
    try {
      response = await dio.post(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
        data: jsonEncode(req),
      );
      filteredDocRes = FilteredDocRes.fromJson(response.data);
      // print(
      //     '$LOGD getAllDoc:Json: ${filteredDocRes.toJson()} -----> ${filteredDocRes.data.length} ');
      if (filteredDocRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<FilteredDocResData> filteredDocResData =
        List<FilteredDocResData>.from(
            list.map((e) => FilteredDocResData.fromJson(e)).toList());
        if(filteredDocResData.length > 0){
          this.allFilteredDocList = filteredDocResData.map((e) => FilteredDocList(data: e)).toList();
/*          allFilteredDocList.forEach((element) {
            print('$LOGD DocName-->${element.doctorName}');
            print('$LOGD DocKey-->${element.doctorKey}');
          });*/
          print('$LOGD Length:getAllDoc:: ${allFilteredDocList.length}');
          modalHudController.changeisLoading(false);
          update();
          return allFilteredDocList;
        }else{
          modalHudController.changeisLoading(false);
          print('$LOGD No getAllDoc :: ${filteredDocRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoAvailableDoctors,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
          );
          allFilteredDocList = null;
          update();
          return allFilteredDocList;
        }
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAvailableDoctors,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
        );
        print('$LOGD No Data :getAllDoc: ${filteredDocRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      // filteredDocRes = FilteredDocRes.fromJson(response);
      this.allFilteredDocList = null;
      update();
      Get.snackbar(
        '', ConstString.NoAvailableDoctors,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
      );
      print('$LOGD catch:1 getAllDoc: ${jsonEncode(e.response.data)} ');
      // print('$LOGD catch:2: ${docAppointmentTableRes.massage.toString()} }');
      // Get.snackbar(
      //     ConstString.ErrorOccurred, errorVaild(registerDocRes.massage[0]),
      //     backgroundColor: Colors.red[600],
      //     colorText: ConstStyles.BaseBackGround);
      // return docAppointmentTableResData;
      return allFilteredDocList;
    }
  }

  Future<List<SearchDocList>> getDocByName(name) async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.SearchDoc +'/'+name;
    print('$LOGD :URL getDocByName: $Url');

    var response;
    // FilteredDocRes filteredDocRes;
    SearchDocRes searchDocRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );

      searchDocRes = SearchDocRes.fromJson(response.data);
      print(
          '$LOGD getDocByName:Json: ${searchDocRes.toJson()} -----> ${searchDocRes.data.length} ');
      if (searchDocRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<SearchDocResData> filteredDocResData =
        List<SearchDocResData>.from(
            list.map((e) => SearchDocResData.fromJson(e)).toList());
        if(filteredDocResData.length > 0){
          this.allSearchedDocList = filteredDocResData.map((e) => SearchDocList(data: e)).toList();
          print('$LOGD Length:getDocByName:: ${allSearchedDocList.length}');
          modalHudController.changeisLoading(false);
          update();
          return allSearchedDocList;
        }else{
          modalHudController.changeisLoading(false);
          print('$LOGD No getDocByName :: ${searchDocRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoAvailableDoctors,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoDoctorsWithThisName),
          );
          docSearchName = null;
          searchDoc = TextEditingController();
          allSearchedDocList = null;
          update();
          return allSearchedDocList;
        }
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAvailableDoctors,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
        );
        print('$LOGD No Data :getDocByName: ${searchDocRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      // filteredDocRes = FilteredDocRes.fromJson(response);
      this.allSearchedDocList = null;
      update();
      Get.snackbar(
        '', ConstString.NoAvailableDoctors,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
      );
      print('$LOGD catch:1 getAllDoc: ${jsonEncode(e.response.data)} ');
      return allSearchedDocList;
    }
  }

  Future<bool> createAppointment(CreateAppointmentReq req) async {
    var Url;
    var response;
    CreateAppointmentRes createAppointmentRes;
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
        print('$LOGD Status:createAppointment: ${createAppointmentRes.status}');
        modalHudController.changeisLoading(false);
        Get.snackbar(
            '', ConstString.AppointmentCreated,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround);
        Get.back();
        update();
        getAllDoc(FilteredDocReq(date: currentDate)).then((value) {
          allFilteredDocList = value;
          filteredDocList = allFilteredDocList;
          update();
        });
        return true;
      }else {
        modalHudController.changeisLoading(false);
        print('$LOGD No Data :createAppointment: ${createAppointmentRes.massage}');
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
      print('$LOGD catch:1:createAppointment: ${jsonEncode(e.response.statusMessage)}  ---->>>> ${createAppointmentRes.massage}');
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

  Future<ProfileResData> getProfileData() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.ShowProfileData +
        '/'+myIdKey.toString() +
        '?token='+myTokenKey;
    print('$LOGD :URL: $Url');
    var response;
    ProfileRes docProfileInfoRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      docProfileInfoRes = ProfileRes.fromJson(response.data);
      print(
          '$LOGD docProfileInfoRes:Json: ${docProfileInfoRes.toJson()}');
      if (docProfileInfoRes.status) {
        modalHudController.changeisLoading(false);
        infoResData = ProfileResData.fromJson(docProfileInfoRes.data.toJson());
        update();
        // getAllCities(getGovId(newGovernment));
        return infoResData;
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      update();
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
    }
  }

  logOut() async{
    // modalHudController.changeisLoading(true);
    var  response;
    LogoutDocRes logoutDocRes;
    String myToken = getStorage.read(ConstString.MyTokenKey);
    print('$LOGD MyToken:Logout: $myToken');
    try {
      response = await dio
          .post(
        EndPoints.LogOutEndPoint+myToken,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      logoutDocRes = LogoutDocRes.fromJson(response.data);
      print('$LOGD LoginDocRes:MSG: ${logoutDocRes.massage[0]}');
      print('$LOGD Res=200:Response: $logoutDocRes');
      print('$LOGD My Token before delete ::: ${getStorage.read(ConstString.MyTokenKey)}');
      getStorage.remove(ConstString.MyTokenKey);
      getStorage.remove(ConstString.MyIdKey);
      print('$LOGD My Token After Deleteing ::: ${getStorage.read(ConstString.MyTokenKey)}');
      // modalHudController.changeisLoading(false);
      Get.offAll(() => Login());

      return logoutDocRes;

    }on DioError catch (e) {
      // modalHudController.changeisLoading(false);
      logoutDocRes = LogoutDocRes.fromJson(e.response.data);
      print('$LOGD catch:1: ${e.response} ');
      print('$LOGD catch:2: ${logoutDocRes.massage.toString()} }');
      Get.snackbar(
          ConstString.ErrorOccurred, logoutDocRes.massage[0],
          backgroundColor: Colors.red[600],
          colorText: ConstStyles.BaseBackGround);
      return logoutDocRes;
    }

  }

  String convertTo12Hr(time){
    DateTime date = DateFormat("h:mm").parse(time); // think this will work better for you
    // print('$LOGD Time :: ${DateFormat('h:mm').format(date)} ---> $time');
    return DateFormat('h:mm').format(date);
  }

  changeSelectedDep(value){
    selectedDep = value;
    update();
  }

  changeSelectedGov(value){
    selectedCity = null;
    selectedGov = value;
    update();
    getAllCities(getGovId(selectedGov));
  }

  changeSelectedCity(value){
    selectedCity = value;
    update();
  }

  int getDepFromName(name){
    for(int i=0 ; i<=specialistDataList.length ; i++){
      // print('$LOGD DepID --> ${name}   ,  Specialist --> ${specialistDataList[i].name}');
      if(name == specialistDataList[i].name){
        return specialistDataList[i].key;
      }
    }
  }

  int getGovId(name){
    // print('$LOGD Gov length --> ${governmentDataList.length} }');
    for(int i=0 ; i<=governmentDataList.length ; i++){
      // print('$LOGD Gov Name --> ${name}   ,  Gov List Name --> ${governmentDataList[i].name}');
      if(name == governmentDataList[i].name){
        return governmentDataList[i].key;
      }
    }
  }

  void filterSearch(String query){
    // searchDoc = query;
    // update();
    print('Tharwat55 SearchDoc:: $query -->> Query:: $searchDoc');
    var dummySearchList = allFilteredDocList;
    if(query.isNotEmpty){
      var dummyListData = List<FilteredDocList>();
      dummySearchList.forEach((item) {
        // var course = FilteredDocResData.fromJson(item.);
        if(item.doctorName.toLowerCase().contains(query.toLowerCase())){
          dummyListData.add(item);
        }
      });
      filteredDocList = [];
      filteredDocList.addAll(dummyListData);
      update();
      return;
    }else{
      filteredDocList = [];
      filteredDocList = allFilteredDocList;
    }
  }

  clearDep(){
    selectedDep = null;
    update();
  }

  clearGov(){
    selectedGov = null;
    citiesDataList = List<CityList>();
    update();
  }

  clearCity(){
    selectedCity = null;
    update();
  }

  clearAllFilters(){
    selectedDep = null;
    selectedGov = null;
    selectedCity = null;
    if(allSearchedDocList != null){
      allSearchedDocList.clear();
    }
    docSearchName = null;
    searchDoc = TextEditingController();
    getCurrentDate();
    citiesDataList = List<CityList>();
    update();
    getAllDoc(null).then((value) {
      filteredDocList = value;
      update();
    });
  }

  search(){
    if(selectedDep !=null){
      FilteredDocReq req = FilteredDocReq(date:currentDate,city: selectedCity,governorate: selectedGov,department: getDepFromName(selectedDep));
      getAllDoc(req).then((value) {
        filteredDocList = value;
        update();
      });
    }else{
      FilteredDocReq req = FilteredDocReq(date:currentDate,city: selectedCity,governorate: selectedGov);
      getAllDoc(req).then((value) {
        filteredDocList = value;
        update();
      });
    }

  }

  getCurrentDate()async{
    now = DateTime.now();
    formatter = DateFormat('yyyy-MM-dd');
    currentDate = formatter.format(now);
    selectedWeekDay = getWeekDay(now.weekday);
    update();
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

  Future<void> selectDate(context) async {
    final DateTime pickedDate = await showDatePicker(
      // locale: const Locale('ar','EG'),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));
    if (pickedDate != null){
      // print('$LOGD dateForAvailableTimes:: ${pickedDate.weekday}');
      selectedWeekDay =  getWeekDay(pickedDate.weekday);
      currentDate = formatter.format(pickedDate);
      update();
      getAllDoc(FilteredDocReq(date: currentDate)).then((value) {
        allFilteredDocList = value;
        filteredDocList = allFilteredDocList;
        update();
      });
    }else{
      selectedWeekDay =  getWeekDay(now.weekday);
      currentDate = formatter.format(now);
      update();
    }
    // print('$LOGD dateForAvailableTimes:: $dateSession');
  }

  changeAppointmentType(newValue){
    appointmentType = newValue;
    update();
    // print('$LOGD changeAppointmentType :: $newValue');
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
    // print('$LOGD changeAppointmentType :: $status_key');
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

  Future<void> notifyCancelPusher() async {
    await Pusher.init(
        DotEnv.env['PUSHER_APP_KEY'],
        PusherOptions(cluster: DotEnv.env['PUSHER_APP_CLUSTER']),
        enableLogging: true
    );

    Pusher.connect();

    channel = await Pusher.subscribe(channelName);
    PusherNotificationRes res;
    channel.bind(eventName, (last) {
      final String data = last.data;
      res = PusherNotificationRes.fromJson(jsonDecode(last.data));
      print('$LOGD Res:Bind--: ${jsonEncode(res)}');
      _inEventData.add(res);
      print('$LOGD Res:_inEventData--: ${_inEventData.toString()}');
    });


    eventStream.listen((data) async {
      notificationPusherList.add(data);
      showNotification('إالغاء جديد',notificationPusherList[0].notifyMessage);
      playLocalAsset();
      // res = PusherNotificationRes.fromJson(data);
      print('$LOGD Res:Event--: ${res.userSender}');
      print('$LOGD :NotificationList: ${res.notifyMessage}  ${notificationPusherList.length}');
    });
    // PusherNotificationRes res = PusherNotificationRes.fromJson(messages[0]);
    // print('$LOGD Res:: ${res.userSender}');
  }

  Future<void> chatPusher() async {
    await Pusher.init(
        DotEnv.env['PUSHER_APP_KEY'],
        PusherOptions(cluster: DotEnv.env['PUSHER_APP_CLUSTER']),
        enableLogging: true
    );

    Pusher.connect();

    chatChannel = await Pusher.subscribe(chatChannelName);

    ChatPusherNotifyRes res;

    chatChannel.bind(chatEventName, (last) {
      res = ChatPusherNotifyRes.fromJson(jsonDecode(last.data));
      print('$LOGD Res:Bind--: ${jsonEncode(res)}');
      _inChatEventData.add(res);
      print('$LOGD Res:_inEventData--: ${_inChatEventData.toString()}');
    });


    chatEventStream.listen((data) async {
      chatPusherList.add(data);
      showNotification('لديك إستفسار جديد', chatPusherList[0].notifyMessage);
      playLocalAsset();
      // res = PusherNotificationRes.fromJson(data);
      print('$LOGD Res:Event--: ${res.message_key}');
      print('$LOGD :NotificationList: ${res.notifyMessage}  ${notificationPusherList.length}');
    });

  }

  Future<void> chatMessagePusher() async {
    await Pusher.init(
        DotEnv.env['PUSHER_APP_KEY'],
        PusherOptions(cluster: DotEnv.env['PUSHER_APP_CLUSTER']),
        enableLogging: true
    );
    Pusher.connect();
    chatMessageChannel = await Pusher.subscribe(chatMessageChannelName);
    ChatMessagePusherRes res;

    chatMessageChannel.bind(chatMessageEventName, (last) {
      res = ChatMessagePusherRes.fromJson(jsonDecode(last.data));
      print('$LOGD Res:Bind--: ${jsonEncode(res)}');
      _inChatMessageEventData.add(res);
      print('$LOGD Res:_inEventData--: ${_inChatMessageEventData.toString()}');
    });


    chatMessageEventStream.listen((data) async {
      //TODO To Refresh
      // getAllChatMessages();
      chatMessagePusherList.add(data);
      if(chatMessagePusherList[0].senderKey != myIdKey){
        showNotification('لديك رسالة جديدة', '');
        playLocalAsset();
      }
    });

  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("audio/notification.mp3");
  }

  //TODO only for android
  notify(){
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  notify2() async{
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var  initializationSettings =new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: Get.context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Get.toNamed('AllDoctors');
/*
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
*/
                },
              )
            ],
          ),
    );
  }

  Future notificationSelected(String payload) async {
/*    showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );*/
  }

  Future showNotification(title,content) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, content,
        generalNotificationDetails, payload: "Task");
    print('$LOGD 000000000000000000000dsadas');

  }
}