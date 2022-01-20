import 'package:e7gz_call_center/Controller/Chats/ChatBoxController.dart';
import 'package:e7gz_call_center/Model/Chat/AllNotifyChatList.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomProfileFormFiled.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomSmallButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/LogoContainer.dart';
import 'package:e7gz_call_center/View/MainDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChatBox extends StatelessWidget {
  AllNotifyChatList _allNotifyChatList = AllNotifyChatList();
  ChatBoxController _controller;
  final _formKey = GlobalKey<FormState>();
  var mWidth, mHeight;
  var _chatKey ;

  ChatBox(this._allNotifyChatList,this._chatKey) {
    if(_chatKey == null){
      _controller = Get.put(ChatBoxController(
          _allNotifyChatList.notifyKey, _allNotifyChatList.messageKey,null));
      _controller.readed(_chatKey);
    }else{
      _controller = Get.put(ChatBoxController(
          null,null,_chatKey));
      _controller.readed(_chatKey);
    }

  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
        ),
        body: GetBuilder<ChatBoxController>(
          builder: (controller){
            return ModalProgressHUD(
              inAsyncCall: _controller.modalHudController.isLoading,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //TODO Old Messages
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: mHeight *0.6,
                          margin: EdgeInsets.only(bottom: mHeight * 0.35),
                          color: ConstStyles.HeadersBackGround,
                          child: GetBuilder<ChatBoxController>(
                            builder: (_){
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  if (controller.allMessages[index].senderKey ==
                                      controller.myIdKey) {
                                    //TODO right
                                    return rightBox(controller.allMessages[index].message);
                                  } else if (controller
                                      .allMessages[index].senderKey !=
                                      controller.myIdKey) {
                                    return leftBox(
                                        controller.allMessages[index].message);
                                  } else {
                                    return LogoContainer();
                                  }
                                },
                                itemCount: controller.allMessages.length,
                              );
                            },
                          )
                      ),
                    ),
                  ),


                  //TODO New Messages
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: mHeight * 0.35,
                        color: ConstStyles.BaseBackGround,
                        padding: EdgeInsets.only(
                            right: mWidth * 0.01, left: mWidth * 0.01),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: mHeight * 0.15,
                              width: mWidth * 0.5,
                              child: ListView(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: mHeight * 0.005),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(color: ConstStyles.FlatIconBackgroundColor,width: 3.5),
                                          // color: ConstStyles.BaseBackGround,
                                        ),
                                        child: CustomSmallButton(text: 'صورة البطاقة , كارنية النقابة',txtColor: ConstStyles.BlackBackGround,color: ConstStyles.BaseBackGround,onClick: ()async{
                                          _controller.message = 'صورة البطاقة , كارنية النقابة';
                                          // _formKey.currentState.save();
                                          await _controller.sendMessage();
                                        },)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: mHeight * 0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: mWidth * 0.7,
                                    // height: mHeight * 0.07,
                                    // color: ConstStyles.FlatIconBackgroundColor,
                                    child: Form(
                                      key: _formKey,
                                      child: CustomProfileFormFiled(
                                        // hint: 'أكتب إستفسارك',
                                        enabled: true,
                                        myController: TextEditingController(
                                          text: _controller.message == null
                                              ? ''
                                              : _controller.message,
                                        ),
                                        onSave: (s) {
                                          _controller.message = s;
                                          print('save');
                                        },
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: mWidth * 0.2,
                                    // color: ConstStyles.BaseBackGround,
                                    child: CustomSmallButton(
                                      text: 'إرسال',
                                      onClick: () async {
                                        _formKey.currentState.save();
                                        await _controller.sendMessage();
                                      },
                                      color: ConstStyles.FlatIconBackgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: mWidth,
                                // height: mHeight * 0.08,
                                child: CustomButton(text: 'إنهاء المحادثة', onClick: (){
                                  if(_chatKey != null){
                                    _controller.closeChat(_chatKey).then((value) {
                                      if(value.status){
                                        Get.back();
                                        Get.offAllNamed('Chats');
                                        Get.snackbar(
                                          '', '',
                                          backgroundColor: ConstStyles.TextBackGround,
                                          colorText: ConstStyles.BaseBackGround,
                                          // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
                                          messageText: CustomHeadersTextWhite(Txt: ConstString.ChatClosedSuccess),
                                        );
                                      }
                                    });
                                  }

                                })),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
    );
  }

  Widget leftBox(msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(
            left: mWidth * 0.025,
            right: mWidth * 0.1,
            top: mHeight * 0.01,
            bottom: mHeight * 0.01),
        margin: EdgeInsets.only(top: mHeight * 0.015),
        decoration: BoxDecoration(
          color: ConstStyles.FlatIconBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )
        ),
        child: SizedBox(
          // width: mWidth * 0.45,
          child: Column(
            children: [
              CustomText(
                Txt: msg,
                // alignText: TextAlign.end,
                color: ConstStyles.BaseBackGround,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget rightBox(msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(
            left: mWidth * 0.1,
            right: mWidth * 0.025,
            top: mHeight * 0.01,
            bottom: mHeight * 0.01),
        margin: EdgeInsets.only(top: mHeight * 0.015),
        decoration: BoxDecoration(
            color: ConstStyles.ViewsBackGround,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            )
        ),
        child: SizedBox(
          // width: mWidth * 0.65,
          child: CustomText(
            Txt: msg,
            color: ConstStyles.BaseBackGround,
          ),
        ),
      ),
    );
  }

}
