
import 'package:e7gz_call_center/Controller/ShowMyAppointments/ShowMyAppointmentsController.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/DaysNums.dart';
import 'package:e7gz_call_center/View/CustomWidget/LogoContainer.dart';
import 'package:e7gz_call_center/View/MainDrawer.dart';
import 'package:e7gz_call_center/View/ShowAppointment/AppointmentsList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ShowMyAppointments extends GetView<ShowMyAppointmentsController> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
   double mHeight = MediaQuery.of(context).size.height;
   double mWidth = MediaQuery.of(context).size.width;
    return  GetBuilder<ShowMyAppointmentsController>(
      init: Get.put(ShowMyAppointmentsController()),
      builder: (controller){
      return  ModalProgressHUD(
        inAsyncCall: controller.modalHudController.isLoading,
          child: Scaffold(
            drawer: MainDrawer(),
            appBar: AppBar(
              title: CustomHeadersTextWhite(Txt: ConstString.Appointments),
            ),
            key: _key,
            body: Container(
              width: mWidth,
              height: mHeight,
              child: LayoutBuilder(builder: (context,constrains){
                var height = constrains.maxHeight;
                var width = constrains.maxWidth;
                return Stack(
                  // fit: StackFit.expand,
                  children: [

                    //TODO Search
                    Positioned.fill(
                      child: Align(
                      widthFactor: width *  0.05,
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.013,right: width * 0.025),
                        height: height * 0.077,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          color: ConstStyles.BaseBackGround,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            controller.filterSearch(value);
                          },
                          controller: controller.search,
                          decoration: InputDecoration(
                              labelText: ConstString.Search,
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              )),
                        ),
                      ),
                    ),),


                    //TODO Days
                    Positioned.fill(
                      child: Align(
                        widthFactor: width * 0.05,
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: height * 0.07),
                          decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    width: width * 0.005,
                                    color: ConstStyles.TextBackGround),
                              )),
                          width: width * 0.15,
                          height: height,
                          child: ListView.builder(
                              padding: EdgeInsets.only(top: height * 0.01),
                              itemCount: controller.numOfDays,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: width * 0.005, right: width * 0.005),
                                  color:
                                  controller.selectedDay - 1 ==
                                      index
                                      ? ConstStyles.HeadersBackGround
                                      : ConstStyles.BaseBackGround,
                                  height: height * 0.05,
                                  child: Center(
                                    child:GestureDetector(
                                      child: DaysNum(
                                        Txt: (index + 1).toString(),
                                      ),
                                      onTap: () {
                                        controller
                                            .changeSelectedDay(index + 1,null);
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),

                    //TODO Center
                    Positioned.fill(
                      child: Align(
                        widthFactor: width,
                        alignment: Alignment.center,
                        child: RefreshIndicator(
                          onRefresh: (){
                            return controller.getAppointmentToday(controller.currentDate);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: height * 0.025),
                            margin: EdgeInsets.only(
                                left: width * 0.15,top: height * 0.079),
                            width: width *0.85,
                            height: height,
                            // color: ConstStyles.BlackBackGround,
                            child: GetBuilder<ShowMyAppointmentsController>(
                                builder: (_) {
                                  if (controller.filteredAppointmentData !=
                                      null &&
                                      controller.filteredAppointmentData.length >
                                          0) {
                                    // controller.modalHudController.changeisLoading(false);
                                    return AppointmentList(
                                        controller.filteredAppointmentData);
                                  } else {
                                    // _key.currentState.showSnackBar(SnackBar(content: CustomHeadersTextWhite(Txt: ConstString.NoAppointment)));
                                    return GestureDetector(child: LogoContainer(),onTap: (){
                                      controller.getAppointmentToday(controller.currentDate);
                                    },);
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),

                    //TODO Month
                    Positioned.fill(
                      child: Align(
                        widthFactor: width,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: ConstStyles.ViewsBackGround,
                          width: width,
                          height: height * 0.07,
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomHeadersTextWhite(
                                  Txt: controller.arabicDate ==
                                      null
                                      ? ''
                                      : '${controller.getWeekDay(controller.now.weekday)} ${controller.arabicDate}',
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: ConstStyles.BaseBackGround,
                                  size: width * 0.09,
                                )
                              ],
                            ),
                            onTap: (){
                              controller.selectDate(context);
                            },
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              },)
            ),
          ),
        );
      },
    );
  }
}
