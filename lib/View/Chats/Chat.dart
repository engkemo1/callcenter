import 'dart:ffi';

import 'package:e7gz_call_center/Controller/Chats/ChatsController.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/Chats/ChatBox.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/LogoContainer.dart';
import 'package:e7gz_call_center/View/MainDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:transparent_image/transparent_image.dart';

class Chat extends GetView<ChatsController> {
  String LOGD = '/ChatScreen';

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ChatsController>(
      init: Get.put(ChatsController()),
      builder: (controller) {
        return ModalProgressHUD(
          inAsyncCall: controller.modalHudController.isLoading,
          child: Scaffold(
            drawer: MainDrawer(),
            appBar: AppBar(
              title: CustomHeadersTextWhite(Txt: ConstString.Chats),
            ),
            body: Stack(
              children: [

                //TODO New Chats notify
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: mHeight * 0.4,
                      // color: ConstStyles.HeadersBackGround,
                      child: RefreshIndicator(
                        onRefresh: (){
                          return controller.getAllChatsNotify();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: mWidth * 0.025,
                              right: mWidth * 0.05,
                              top: mHeight * 0.02),
                          child: GetBuilder<ChatsController>(
                            builder: (cont) {
                              if (cont.allChatsNotify != null &&
                                  cont.allChatsNotify.length > 0) {
                                return ListView.separated(
                                  itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: ConstStyles.TextBackGround,
                                              blurRadius: 2.0,
                                              spreadRadius: 1.0,
                                              offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.only(right: mWidth * 0.015,left: mWidth * 0.015,top: mWidth * 0.025,bottom: mWidth * 0.025),
                                        child: GestureDetector(
                                          onTap: () {
                                            print(
                                                '$LOGD ${controller.allChatsNotify[index].messageKey} -- ${controller.allChatsNotify[index].notifyKey}');
                                            Get.back();
                                            Get.to(()=>ChatBox(controller.allChatsNotify[index],null));
                                          },
                                          child: CustomText(
                                            Txt:
                                            '${controller.allChatsNotify[index].notifyMessage} ',
                                            color: ConstStyles.BlackBackGround,
                                            alignText: TextAlign.start,
                                          ),
                                        ),
                                      );
                                  },
                                  separatorBuilder: (BuildContext context, int index) =>
                                      Divider(),
                                  itemCount: controller.allChatsNotify.length,
                                );
                              } else {
                                return GestureDetector(
                                    onTap: (){
                                      controller.getAllChatsNotify();
                                    },
                                    child: LogoContainer());
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //TODO Old chats
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: mHeight * 0.4,
                      color: ConstStyles.HeadersBackGround,
                      padding: EdgeInsets.only(bottom: mHeight * 0.02),
                      child: RefreshIndicator(
                        onRefresh: (){
                          return controller.getOldChats();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: mWidth * 0.025,
                              right: mWidth * 0.025,
                              top: mHeight * 0.02),
                          child: GetBuilder<ChatsController>(
                            builder: (cont) {
                              if (cont.allOldChats != null &&
                                  cont.allOldChats.length > 0) {
                                return ListView.separated(
                                  itemBuilder: (BuildContext context, int index) {
                                    //TODO Read or not
                                    if(controller.allOldChats[index].read ==1){
                                      print('$LOGD :: ${controller.allOldChats[index].doctorId} ----------- ${controller.myIdKey}');
                                      return GestureDetector(
                                        onTap: () {
                                          print(
                                              '$LOGD ${controller.allOldChats[index].doctorName} -- ${controller.allOldChats[index].chatKey}');
                                          Get.back();
                                          Get.to(()=>ChatBox(null,controller.allOldChats[index].chatKey));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: ConstStyles.TextBackGround,
                                                blurRadius: 2.0,
                                                spreadRadius: 1.0,
                                                offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                              )
                                            ],
                                          ),
                                          padding: EdgeInsets.only(right: mWidth * 0.015,left: mWidth * 0.015,top: mWidth * 0.015,bottom: mWidth * 0.015),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: mWidth * 0.18,
                                                height: mHeight*0.1,
                                                margin: EdgeInsets.only(top: mHeight * 0.015),
                                                child: controller.allOldChats[index].doctorAvatar == null ? Icon(Icons.person,size: mWidth * 0.18,color: ConstStyles.ViewsBackGround,)
                                                    :docPic(EndPoints.ImagesUrl + controller.allOldChats[index].doctorAvatar),
                                              ),

                                              SizedBox(width: mWidth * 0.025,),

                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    Txt:
                                                    '${controller.allOldChats[index].doctorName} ',
                                                    color: ConstStyles.BlackBackGround,
                                                    alignText: TextAlign.start,
                                                  ),

                                                  SizedBox(height: mHeight * 0.01,),

                                                  CustomText(
                                                    Txt:
                                                    '${controller.allOldChats[index].lastMessage} ',
                                                    color: ConstStyles.BlackBackGround,
                                                    alignText: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }else{
                                      print('$LOGD :: false111111111111111111111111');
                                      return GestureDetector(
                                        onTap: () {
                                          print(
                                              '$LOGD ${controller.allOldChats[index].doctorName} -- ${controller.allOldChats[index].chatKey}');
                                          Get.back();
                                          Get.to(()=>ChatBox(null,controller.allOldChats[index].chatKey));
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: ConstStyles.TextBackGround,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 1.0,
                                                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                                  )
                                                ],
                                              ),
                                              padding: EdgeInsets.only(right: mWidth * 0.015,left: mWidth * 0.015,top: mWidth * 0.015,bottom: mWidth * 0.015),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: mWidth * 0.18,
                                                    height: mHeight*0.1,
                                                    margin: EdgeInsets.only(top: mHeight * 0.015),
                                                    child: controller.allOldChats[index].doctorAvatar == null ? Icon(Icons.person,size: mWidth * 0.18,color: ConstStyles.ViewsBackGround,)
                                                        :docPic(EndPoints.ImagesUrl + controller.allOldChats[index].doctorAvatar),
                                                  ),

                                                  SizedBox(width: mWidth * 0.025,),

                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomText(
                                                        Txt:
                                                        '${controller.allOldChats[index].doctorName} ',
                                                        color: ConstStyles.BlackBackGround,
                                                        alignText: TextAlign.start,
                                                      ),

                                                      SizedBox(height: mHeight * 0.01,),

                                                      CustomText(
                                                        Txt:
                                                        '${controller.allOldChats[index].lastMessage} ',
                                                        color: ConstStyles.BlackBackGround,
                                                        alignText: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              // right: 0,
                                              child:  Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  width: mWidth * 0.01,
                                                  height: mWidth * 0.01,
                                                  decoration: new BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 12,
                                                    minHeight: 12,
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      );

                                    }
                                  },
                                  separatorBuilder: (BuildContext context, int index) =>
                                      Divider(),
                                  itemCount: controller.allOldChats.length,
                                );
                              }
                              else {return GestureDetector(
                                    onTap: (){
                                      controller.getOldChats();
                                    },
                                    child: LogoContainer());}
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget myNotification(counter) {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.notifications,
        ),
        Positioned(
          right: 0,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: new Text(
              '$counter',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget docPic(url) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator())),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.fill,
                imageScale: 1.0,
                placeholder: kTransparentImage,
                image: url,
              ),
            ),
          ),
        ),
      ],
    );
  }

}

//TODO DropdownButton Notification
/*
Stack(
children: [
Positioned.fill(
child: Align(
alignment: Alignment.topLeft,
child: DropdownButton(
items: controller.allChatsNotify.map((item) {
return DropdownMenuItem(
value: item.notifyMessage,
child: Container(
width: mWidth * 0.75,
decoration: BoxDecoration(
border: Border(
bottom: BorderSide(width: mWidth * 0.003, color: ConstStyles.ViewsBackGround),
)
),
child: CustomText(
Txt: item.notifyMessage,
size: 16,
color: ConstStyles.BlackBackGround,
),
));
}).toList(),
onChanged: (value) {
// _controller.changeSelectedGov(value);
},
// value: _controller.selectedGov,
dropdownColor: ConstStyles.HeadersBackGround,
icon: Container(
width: mWidth * 0.1,
child:
myNotification(controller.allChatsNotify.length)),
iconEnabledColor: ConstStyles.ViewsBackGround,
elevation: 10,
),
),
),
],
),*/
