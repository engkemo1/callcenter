import 'package:e7gz_call_center/Controller/Notification/ShowAllNotificationController.dart';
import 'package:e7gz_call_center/Controller/ShowMyAppointments/ConfirmCanceledController.dart';
import 'package:e7gz_call_center/Model/Notification/AllNotificationList.dart';
import 'package:e7gz_call_center/Model/Notification/AppointmentsReq.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/Notification/ShowAllNotification.dart';
import 'package:e7gz_call_center/View/ShowAppointment/AppointmentsList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ConfirmCanceled extends StatelessWidget {

  AllNotificationList _notificationItem = AllNotificationList();
  ConfirmCanceledController controller;

  ConfirmCanceled(this._notificationItem) {
    controller = Get.put(ConfirmCanceledController(_notificationItem.userSender,_notificationItem.date,_notificationItem.notifyKey));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        appBar: AppBar(
          title: CustomHeadersTextWhite(Txt: ConstString.ConfirmCanceled),
        ),
        body: GetBuilder<ConfirmCanceledController>(
          builder: (_) {
            return ModalProgressHUD(
              inAsyncCall: controller.modalHudController.isLoading,
              child: Padding(
                padding: EdgeInsets.only(top: height*0.02,left: width * 0.02,right: width * 0.02),
                child: AppointmentList(
                    controller.allAppointmentData),
              ),
            );
          },
        )
    );
  }
}
