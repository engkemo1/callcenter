import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Chat/AllNotifyChatList.dart';
import 'package:e7gz_call_center/Model/Chat/AllNotifyChatRes.dart';
import 'package:e7gz_call_center/Model/Chat/AllNotifyChatResData.dart';
import 'package:e7gz_call_center/Model/Chat/ChatPusherNotifyRes.dart';
import 'package:e7gz_call_center/Model/Chat/OldChats/OldChatsList.dart';
import 'package:e7gz_call_center/Model/Chat/OldChats/OldChatsRes.dart';
import 'package:e7gz_call_center/Model/Chat/OldChats/OldChatsResData.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'as DotEnv;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pusher_websocket_flutter/pusher.dart';

class ChatsController extends GetxController{
  String LOGD = '/ChatsController';
  final ModalHudController modalHudController = Get.put(ModalHudController());
  var dio = Dio();
  final getStorage = GetStorage();
  var myTokenKey, myIdKey;
  List<AllNotifyChatList> allChatsNotify = List<AllNotifyChatList>().obs;
  List<OldChatsList> allOldChats = List<OldChatsList>().obs;


  //TODO Chat
  StreamController<ChatPusherNotifyRes> _chatEventData = StreamController<ChatPusherNotifyRes>();
  Sink get _inChatEventData => _chatEventData.sink;
  Stream get chatEventStream => _chatEventData.stream;
  Channel chatChannel;
  String chatChannelName = 'supportChat';
  String chatEventName = 'supportChat';
  List<ChatPusherNotifyRes> chatPusherList = new List<ChatPusherNotifyRes>().obs;


  @override
  void onInit() async {
    myTokenKey =getStorage.read(ConstString.MyTokenKey);
    myIdKey =  getStorage.read(ConstString.MyIdKey);
    chatPusher();
    update();
    super.onInit();
  }

  Future<List<AllNotifyChatResData>> getAllChatsNotify() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.ChatNotification+'?token=' + myTokenKey;
    print('$LOGD getAllNotification:URL: $Url');
    var response;
    AllNotifyChatRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = AllNotifyChatRes.fromJson(response.data);
      print(
          '$LOGD getAllNotification:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<AllNotifyChatResData> specialistResData =
        List<AllNotifyChatResData>.from(
            list.map((e) => AllNotifyChatResData.fromJson(e)).toList());
        print('$LOGD getAllNotification::: ${specialistResData.length}');
        if(specialistResData.length > 0){
          this.allChatsNotify = specialistResData.map((e) => AllNotifyChatList(data: e)).toList();
          print('$LOGD getAllNotification::: ${allChatsNotify[0].notifyMessage}');
          modalHudController.changeisLoading(false);
          update();
          return specialistResData;
        }else{
          modalHudController.changeisLoading(false);
          print('$LOGD getAllNotification Data000 :: ${specialistRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoNewChats,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoNewChats),
          );
          return specialistResData;
        }
      }
      else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoNewChats,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoNewChats),
        );
        print('$LOGD No Data :getAllNotification: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = AllNotifyChatRes.fromJson(e.response.data);
      this.allChatsNotify = null;
      update();
      Get.snackbar(
        '', ConstString.NoNewChats,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoNewChats),
      );
    }
  }

  Future<List<OldChatsResData>> getOldChats() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.OldChats+'?token=' + myTokenKey;
    print('$LOGD getOldChats:URL: $Url');
    var response;
    OldChatsRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = OldChatsRes.fromJson(response.data);
      print(
          '$LOGD getOldChats:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<OldChatsResData> specialistResData =
        List<OldChatsResData>.from(
            list.map((e) => OldChatsResData.fromJson(e)).toList());
        print('$LOGD getOldChats::: ${specialistResData.length}');
        if(specialistResData.length > 0){
          this.allOldChats = specialistResData.map((e) => OldChatsList(data: e)).toList();
          print('$LOGD getOldChats::: ${allOldChats[0].doctorName}');
          modalHudController.changeisLoading(false);
          update();
          return specialistResData;
        }else{
          modalHudController.changeisLoading(false);
          print('$LOGD getOldChats Data000 :: ${specialistRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.NoOldChats,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.NoOldChats),
          );
          return specialistResData;
        }
      }
      else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoOldChats,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoOldChats),
        );
        print('$LOGD No Data :getOldChats: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = OldChatsRes.fromJson(e.response.data);
      this.allOldChats = null;
      update();
      Get.snackbar(
        '', ConstString.NoOldChats,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoOldChats),
      );
    }
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
      playLocalAsset();
      getAllChatsNotify();
      getOldChats();
      print('$LOGD Res:Event--: ${res.message_key}');
    });

  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("audio/notification.mp3");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print('$LOGD closeeee');

    super.onClose();

  }

  @override
  void onReady() async{
    // TODO: implement onReady
    print('$LOGD Readyyyy');
    await getAllChatsNotify();
    await getOldChats();
    super.onReady();
  }

}