
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Chat/ChatId/ChatIdRes.dart';
import 'package:e7gz_call_center/Model/Chat/ChatId/ChatIdResData.dart';
import 'package:e7gz_call_center/Model/Chat/ChatMessages/ChatMessagesList.dart';
import 'package:e7gz_call_center/Model/Chat/ChatMessages/ChatMessagesRes.dart';
import 'package:e7gz_call_center/Model/Chat/ChatMessages/ChatMessagesResData.dart';
import 'package:e7gz_call_center/Model/Chat/CloseChat/CloseChatRes.dart';
import 'package:e7gz_call_center/Model/Chat/ReadLastMessage/ReadLastMessageRes.dart';
import 'package:e7gz_call_center/Model/Chat/SendMessage/SendMessageRes.dart';
import 'package:e7gz_call_center/Model/ChatMessagePusherRes.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class ChatBoxController extends GetxController{
  String LOGD = '/ChatBoxController';
  var myTokenKey,myIdKey;
  ModalHudController modalHudController = Get.put(ModalHudController());
  final getStorage = GetStorage();
  var dio = Dio();
  var notifyKey,messageKey,chatId;
  var message;
  var chatKeyReq;

  List<ChatMessagesList> allMessages = List<ChatMessagesList>().obs;

  //TODO Chat
  StreamController<ChatMessagePusherRes> _chatEventData = StreamController<ChatMessagePusherRes>();
  Sink get _inChatEventData => _chatEventData.sink;
  Stream get chatEventStream => _chatEventData.stream;
  Channel chatChannel;
  String chatChannelName = 'chatMessage';
  String chatEventName = 'chatMessage';
  List<ChatMessagePusherRes> chatPusherList = new List<ChatMessagePusherRes>().obs;

  ChatBoxController(this.notifyKey,this.messageKey,this.chatId){
    myTokenKey = getStorage.read(ConstString.MyTokenKey);
    myIdKey = getStorage.read(ConstString.MyIdKey);
    update();
    if(chatId == null){
      getChatId(notifyKey, messageKey).then((value) {
        print('$LOGD THEN:: $value');
        chatKeyReq = value;
        update();
        getAllChatMessages(value);
      });
    }else{
      chatKeyReq = chatId;
      getAllChatMessages(chatId);
      update();
    }


  }

  @override
  void onReady() async{
     chatPusher();
  }

  Future<int> getChatId(notifyKey,messageKey) async {
    // modalHudController.changeisLoading(true);
    // update();
    var params = {
      'notify_key': notifyKey,
      'massage_key': messageKey,
    };
    print('$LOGD :Request: ${jsonEncode(params)}');
    var Url = EndPoints.ChatReceipt +
        '?token='+myTokenKey;
    print('$LOGD :URL: $Url');

    var response;
    ChatIdRes chatIdRes;

    try {
      response = await dio.post(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
        data: jsonEncode(params),
      );
      chatIdRes = ChatIdRes.fromJson(response.data);
      print(
          '$LOGD chatIdRes:Json: ${chatIdRes.toJson()} -----> ${chatIdRes.data.chatKey} ');
      if (chatIdRes.status ) {
        // modalHudController.changeisLoading(false);
        update();
        // ChatIdResData chatIdResData = ChatIdResData.fromJson();
        print('$LOGD chatIdRes::: ${chatIdRes.data.chatKey}');
        return chatIdRes.data.chatKey;
      }else {
        // modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.ErrorOccurred,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
          messageText: CustomHeadersTextWhite(Txt: ConstString.ErrorOccurred),
        );
        print('$LOGD No Data :: ${chatIdRes.massage}');
        return null;
      }
    } on DioError catch (e) {
      // modalHudController.changeisLoading(false);
      chatIdRes = ChatIdRes.fromJson(e.response.data);
      update();
      Get.snackbar(
        '', ConstString.NoAppointment,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAppointment),
      );
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
      return null;
    }
  }

  Future<List<ChatMessagesResData>> getAllChatMessages(chatId) async {
    // modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.ChatMessages + '/' + chatId.toString() + '?token=' + myTokenKey;
    print('$LOGD getAllNotification:URL: $Url');
    var response;
    ChatMessagesRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = ChatMessagesRes.fromJson(response.data);
      print(
          '$LOGD getAllNotification:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<ChatMessagesResData> specialistResData =
        List<ChatMessagesResData>.from(
            list.map((e) => ChatMessagesResData.fromJson(e)).toList());
        print('$LOGD getAllNotification::: ${specialistResData.length}');
        this.allMessages = specialistResData.map((e) => ChatMessagesList(data: e)).toList();
        print('$LOGD getAllNotification::: ${allMessages[0].message}');
        // modalHudController.changeisLoading(false);
        update();
        return specialistResData;
      }
      else {
        // modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoNewMessages,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoNewMessages),
        );
        print('$LOGD No Data :getAllNotification: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      // modalHudController.changeisLoading(false);
      print('$LOGD No Data :getAllNotification: ${e}');
      specialistRes = ChatMessagesRes.fromJson(e.response.data);
      this.allMessages = null;
      update();
      Get.snackbar(
        '', ConstString.NoNewMessages,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoNewMessages),
      );
    }
  }

  Future<SendMessageRes> sendMessage() async {
    // modalHudController.changeisLoading(true);
    update();
    var params = {
      'chat_key': chatKeyReq,
      'message': message,
    };
    print('$LOGD params:sendMessage: ${jsonEncode(params)}');

    var url = EndPoints.SendMessage + '?token='+myTokenKey;
    print('$LOGD url:sendMessage: ${url}');

    var response;
    SendMessageRes sendMessageRes;

    try {
      response = await dio
          .post(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
        data: jsonEncode(params),
      );
      sendMessageRes = SendMessageRes.fromJson(response.data);
      print('$LOGD sendMessage:JsonRes: ${sendMessageRes.toJson()}');
      print('$LOGD sendMessage ${sendMessageRes.status} --> ${sendMessageRes.massage}');
      if(sendMessageRes.status){
        // modalHudController.changeisLoading(false);
        update();
        getAllChatMessages(chatKeyReq);
        message = null;
        update();
      }
      return sendMessageRes;

    } on DioError catch (e) {
      // modalHudController.changeisLoading(false);
      update();
      sendMessageRes = SendMessageRes.fromJson(e.response.data);
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
      print('$LOGD catch:2: ${sendMessageRes.massage.toString()} }');
      Get.snackbar(
        '', ConstString.ErrorOccurred,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.MessageNotSent),
      );
      return sendMessageRes;
    }

  }

  Future<ReadLastMessageRes> readed(key)async{
    // modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.SetReadLastMsg + '/' + key.toString() + '?token=' + myTokenKey;
    print('$LOGD readed:URL: $Url');
    var response;
    ReadLastMessageRes readLastMessageRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      readLastMessageRes = ReadLastMessageRes.fromJson(response.data);
      print(
          '$LOGD getAllNotification:Json: ${readLastMessageRes.toJson()} } ');
      if (readLastMessageRes.status ) {
        final result = response.data;
        print('$LOGD getAllNotification::: ${readLastMessageRes.status}');
        // modalHudController.changeisLoading(false);
        update();
        return readLastMessageRes;
      }
    } on DioError catch (e) {
      // modalHudController.changeisLoading(false);
      print('$LOGD No Data :getAllNotification: ${e}');
      readLastMessageRes = ReadLastMessageRes.fromJson(e.response.data);
      this.allMessages = null;
      update();
      Get.snackbar(
        '', ConstString.ErrorOccurred,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.ErrorOccurred),
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
    ChatMessagePusherRes res;

    chatChannel.bind(chatEventName, (last) {
      res = ChatMessagePusherRes.fromJson(jsonDecode(last.data));
      print('$LOGD Res:Bind--: ${jsonEncode(res)}');
      _inChatEventData.add(res);
      print('$LOGD Res:_inEventData--: ${_inChatEventData.toString()}');
    });


    chatEventStream.listen((data) async {
      //TODO To Refresh
      getAllChatMessages(chatId);
      // playLocalAsset();
      chatPusherList.add(data);
    });

  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("audio/notification.mp3");
  }

  Future<CloseChatRes> closeChat(chatKey) async {
    modalHudController.changeisLoading(true);
    update();
    print('$LOGD CloseChat :chatKey: $chatKey');

    var Url = EndPoints.CloseChat +
        '/'+chatKey.toString()+
        '?token='+myTokenKey;
    print('$LOGD CloseChat :URL: $Url');

    var response;
    CloseChatRes closeChatRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      closeChatRes = CloseChatRes.fromJson(response.data);
      print(
          '$LOGD CloseChat:Json: ${closeChatRes.toJson()} -----> ${closeChatRes.data} ');
      if (closeChatRes.status ) {
        modalHudController.changeisLoading(false);
        update();
        // ChatIdResData chatIdResData = ChatIdResData.fromJson();
        print('$LOGD CloseChat::: ${closeChatRes.massage}');

        return closeChatRes;
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.ErrorOccurred,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
          messageText: CustomHeadersTextWhite(Txt: ConstString.ErrorOccurred),
        );
        print('$LOGD CloseChat No Data :: ${closeChatRes.massage}');
        return null;
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      // closeChatRes = CloseChatRes.fromJson(e.response.data);
      print('$LOGD CloseChat catch:1: ${jsonEncode(e.response.data)} ');
      update();
      Get.snackbar(
        '', ConstString.ErrorOccurred,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.ErrorOccurred),
      );
      return null;
    }
  }

}