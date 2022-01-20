import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsController.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/NavigationText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MainDrawer extends GetView<AllDoctorsController> {
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: GetBuilder<AllDoctorsController>(
        init: Get.put(AllDoctorsController()),
        builder: (_controller) {
          return ModalProgressHUD(
            inAsyncCall: _controller.modalHudController.isLoading,
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: ConstStyles.ViewsBackGround),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //TODO Header User Full Name
                      CustomHeadersTextWhite(Txt: _controller.infoResData.name),
                      SizedBox(
                        height: 1,
                      ),
                      //TODO Headers User Email
                      CustomHeadersTextWhite(
                          Txt: _controller.infoResData.email),
                    ],
                  ),
                ),

                //TODO Profile
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: ConstStyles.ViewsBackGround,
                  ),
                  title: NavigationText(
                    Txt: ConstString.Profile,
                  ),
                  onTap: () async {
                    print('Nav :: Profile Clicked');
                    Navigator.pop(context);
                    Get.back();
                    Get.toNamed('Profile');
                    // await _controller.changeHomeState(ConstString.Profile,Profile());
                    // Navigator.pop(context);
                    // print('$LOGD :: Profile Clicked');
                  },
                ),

                //TODO All Doctors
                ListTile(
                  leading: Icon(
                    Icons.apartment,
                    color: ConstStyles.ViewsBackGround,
                  ),
                  title: NavigationText(
                    Txt: ConstString.AllDoctors,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    Get.back();
                    Get.offAllNamed('AllDoctors');
                    // await _controller.changeHomeState(ConstString.AllDoctors,AllDoctors());
                    // Navigator.pop(context);
                  },
                ),

                //TODO Show My Appointment
                ListTile(
                  leading: Icon(
                    Icons.event_note_sharp,
                    color: ConstStyles.ViewsBackGround,
                  ),
                  title: NavigationText(
                    Txt: ConstString.Appointments,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    Get.back();
                    Get.toNamed('ShowMyAppointments');
                    // await _controller.changeHomeState(ConstString.Appointments,ShowMyAppointments());
                    // Navigator.pop(context);
                  },
                ),

                //TODO chat
                GetBuilder<AllDoctorsController>(builder: (cont) {
                  if (cont.chatMessagePusherList.length > 0) {
                    return Obx(
                      () => ListTile(
                        leading: Container(
                          width: mWidth * 0.1,
                          child: _controller.chatMessagePusherList.length > 0
                              ? Center(
                                  child: chatIcon(
                                      _controller.chatMessagePusherList.length))
                              : Center(
                                  child: Icon(
                                    Icons.chat,
                                    color: ConstStyles.ViewsBackGround,
                                  ),
                                ),
                        ),
                        title: NavigationText(
                          Txt: ConstString.Chats,
                        ),
                        onTap: () {
                          print('Nav :: Contact Us Clicked');
                          Navigator.pop(context);
                          Get.back();
                          cont.chatMessagePusherList.clear();
                          Get.toNamed('Chats');
                        },
                      ),
                    );
                  } else if (cont.chatPusherList.length > 0) {
                    return Obx(
                          () => ListTile(
                        leading: Container(
                          width: mWidth * 0.1,
                          child: _controller.chatPusherList.length > 0
                              ? Center(
                              child: chatIcon(
                                  _controller.chatPusherList.length))
                              : Center(
                            child: Icon(
                              Icons.chat,
                              color: ConstStyles.ViewsBackGround,
                            ),
                          ),
                        ),
                        title: NavigationText(
                          Txt: ConstString.Chats,
                        ),
                        onTap: () {
                          print('Nav :: Contact Us Clicked');
                          Navigator.pop(context);
                          Get.back();
                          cont.chatPusherList.clear();
                          Get.toNamed('Chats');
                        },
                      ),
                    );
                  } else {
                    return ListTile(
                      leading: Container(
                        width: mWidth * 0.1,
                        child: Center(
                          child: Icon(
                            Icons.chat,
                            color: ConstStyles.ViewsBackGround,
                          ),
                        ),
                      ),
                      title: NavigationText(
                        Txt: ConstString.Chats,
                      ),
                      onTap: () {
                        print('Nav :: Contact Us Clicked');
                        Navigator.pop(context);
                        Get.back();
                        Get.toNamed('Chats');
                      },
                    );
                  }
                }),

                //TODO Logout
                ListTile(
                  leading:
                      Icon(Icons.logout, color: ConstStyles.ViewsBackGround),
                  title: NavigationText(Txt: ConstString.LogOut),
                  onTap: () async {
                    await _controller.logOut();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget chatIcon(counter) {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.chat,
          color: ConstStyles.ViewsBackGround,
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
                color: ConstStyles.ViewsBackGround,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
