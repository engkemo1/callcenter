/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Logout/LogoutDocRes.dart';
import 'package:e7gz_call_center/Model/Notification/PusherNotificationRes.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileRes.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileResData.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/CustomWidget/LogoContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pusher_websocket_flutter/pusher.dart';

class HomeController extends GetxController{
  String LOGD = '/HomeController';
  Widget docHomeBody;
  var dio = Dio();
  String appTitle;
  final getStorage = GetStorage();
  var keyId, token;
  final ModalHudController modalHudController = Get.put(ModalHudController());
  ProfileResData infoResData = ProfileResData();

 //TODO Notification
  StreamController<NotificationRes> _eventData = StreamController<NotificationRes>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;
  Channel channel;
  String channelName = 'NotifyCallcenter';
  String eventName = 'NotifyCallcenter';
  List<NotificationRes> notificationList = List<NotificationRes>().obs;

  @override
  void onInit() async{
    keyId =getStorage.read(ConstString.MyIdKey).toString();
    token =  getStorage.read(ConstString.MyTokenKey);
    appTitle = ConstString.Welcome + ' ' + ConstString.AppName;
    update();
    initPusher();
    super.onInit();
  }


  @override
  void onReady() async{
    docHomeBody = LogoContainer();
    infoResData = await getProfileData();
    appTitle = ConstString.AllDoctors;
    docHomeBody = AllDoctors();
  }

  Future<void> initPusher() async {
    await Pusher.init(
        DotEnv().env['PUSHER_APP_KEY'],
        PusherOptions(cluster: DotEnv().env['PUSHER_APP_CLUSTER']),
        enableLogging: true
    );

    Pusher.connect();

    channel = await Pusher.subscribe(channelName);
    NotificationRes res;
    channel.bind(eventName, (last) {
      final String data = last.data;
       res = NotificationRes.fromJson(jsonDecode(last.data));
      print('$LOGD Res:Bind--: ${jsonEncode(res)}');
      _inEventData.add(res);
      print('$LOGD Res:_inEventData--: ${_inEventData.toString()}');
    });


    eventStream.listen((data) async {
      notificationList.add(data);
      playLocalAsset();
       // res = NotificationRes.fromJson(data);
      print('$LOGD Res:Event--: ${res.userSender}');
      print('$LOGD :NotificationList: ${res.notifyMessage}  ${notificationList.length}');
    });
    // NotificationRes res = NotificationRes.fromJson(messages[0]);
    // print('$LOGD Res:: ${res.userSender}');
  }


  Future<ProfileResData> getProfileData() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.ShowProfileData +
        '/'+keyId +
        '?token='+token;
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

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("audio/notification.mp3");
  }

  Widget changeHomeState(String title,Widget widget) {
    appTitle = title;
    docHomeBody = widget;
    update();
    print('$LOGD : $docHomeBody --> $appTitle');
    return widget;
  }

}*/
