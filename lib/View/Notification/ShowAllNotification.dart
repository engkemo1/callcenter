import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsController.dart';
import 'package:e7gz_call_center/Controller/Notification/ShowAllNotificationController.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersText.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/LogoContainer.dart';
import 'package:e7gz_call_center/View/MainDrawer.dart';
import 'package:e7gz_call_center/View/Notification/ConfirmCanceled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ShowAllNotification extends StatelessWidget {
  String LOGD = '/ShowAllNotification';
  ShowAllNotificationController _controller =
      Get.put(ShowAllNotificationController());

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: CustomHeadersTextWhite(Txt: ConstString.Notifications),
      ),
      body: GetBuilder<ShowAllNotificationController>(
        builder: (_){
          return ModalProgressHUD(
            inAsyncCall: _controller.modalHudController.isLoading,
            child: RefreshIndicator(
              onRefresh: (){
                return _controller.getAllNotification();
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: mWidth * 0.025,
                    right: mWidth * 0.05,
                    top: mHeight * 0.02),
                child: GetBuilder<ShowAllNotificationController>(
                  builder: (cont){
                    if(cont.allNotificationReversedList != null && cont.allNotificationReversedList.length>0){
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return GetBuilder<AllDoctorsController>(
                            builder: (ct){
                              return Container(
                                padding: EdgeInsets.only(
                                    top: mHeight * 0.02),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: (){
                                          print('$LOGD ${_controller.allNotificationReversedList[index].notifyKey}');
                                          ct.notificationPusherList.clear();
                                          Get.to(()=>ConfirmCanceled(_controller.allNotificationReversedList[index]));
                                        },
                                        child: CustomText(
                                          Txt:
                                          '${_controller.allNotificationReversedList[index].notifyMessage}  ${_controller.allNotificationReversedList[index].date}',
                                          color: ConstStyles.BlackBackGround,
                                          alignText: TextAlign.start,
                                        ),
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: CustomText(
                                        Txt:
                                        '${_controller.allNotificationReversedList[index].createAt}',
                                        color: ConstStyles.TextBackGround,
                                        alignText: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: _controller.allNotificationReversedList.length,
                      );
                    }else{
                      return GestureDetector(
                        child: LogoContainer(),
                      onTap: (){
                        _controller.getAllNotification();
                      },);
                    }
                  },
                )
              ),
            ),
          );
        },
      )
    );
  }
}
