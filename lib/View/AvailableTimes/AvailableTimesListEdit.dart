import 'package:e7gz_call_center/Controller/EditAppointment/EditAppointmentController.dart';
import 'package:e7gz_call_center/Model/ShowAvailableTimes/AvailableTimesData.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableTimesListEdit extends StatelessWidget {
  String LOGD = '/AppointmentList';
  List<AvailableTimes> _availableTimes;
  var _docKey;
  var height, width;

  AvailableTimesListEdit(this._availableTimes,this._docKey);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.0125,
      width: width,
      child: ListView.builder(
        padding: EdgeInsets.only(top: height * 0.01),
        itemCount: _availableTimes.length,
        itemBuilder: (context, index) {
          return ContainerList(index);
        },
      ),
    );
  }

  String getArabicDay(day) {
    switch (day) {
      case 'sat':
        return 'السبت';
      case 'sun':
        return 'الأحد';
      case 'mon':
        return 'الأثنين';
      case 'tue':
        return 'الثلاثاء';
      case 'wed':
        return 'الأربعاء';
      case 'Tue':
        return 'الخميس';
      case 'fri':
        return 'الجمعة';
    }
  }

  Widget ContainerList(index) {
    return GetBuilder<EditAppointmentController>(
        init: Get.put(EditAppointmentController(_docKey)),
        builder: (_appointmentController){
          return GestureDetector(
            child: Container(
              width: width,
              height: height /20,
              decoration: BoxDecoration(
                border: Border.all(color: ConstStyles.HeadersBackGround,width: 2),
                color:
                _appointmentController.selectedList ==
                    index
                    ? ConstStyles.HeadersBackGround
                    : ConstStyles.BaseBackGround,
              ),
              child: LayoutBuilder(
                builder: (context,constrains){
                  var localHeight = constrains.maxHeight;
                  var localWidth = constrains.maxWidth;
                  print('Local Width : $localWidth');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //TODO Available or not
                      Container(
                        // margin: EdgeInsets.only(top: localHeight * 0.01,right: localWidth * 0.01),
                        width: localWidth /15,
                        height: localWidth /15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _availableTimes[index].timeStatus == 'available'
                                ? ConstStyles.TimeStatusAvailable
                                : ConstStyles.TimeStatusUnAvailable),
                      ),
                      SizedBox(width: localWidth /5,child: CustomText(Txt: ConstString.From)),
                      Expanded(child: SizedBox(width: localWidth /3.8,child: CustomText(Txt: _appointmentController.convertTo12Hr(_availableTimes[index].timeFrom.substring(0,5))))),
                      SizedBox(width: localWidth /5,child: CustomText(Txt: ConstString.To)),
                      SizedBox(width: localWidth /3.8,child: CustomText(Txt: _appointmentController.convertTo12Hr(_availableTimes[index].timeTo.substring(0,5)))),
                    ],
                  );
                },
              ),
            ),
            onTap: (){
              _appointmentController.changeSelectedList(index);
              _appointmentController.changeSelectedTimeKey(_availableTimes[index].key);
            },
          );
        });
  }
}

