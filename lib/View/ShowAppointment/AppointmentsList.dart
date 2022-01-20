import 'package:e7gz_call_center/Model/Appointments/AppointmentData.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomSmallButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/DaysNums.dart';
import 'package:e7gz_call_center/View/EditAppointment/EditAppointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentList extends StatelessWidget {
  String LOGD = '/AppointmentList';
  List<AppointmentData> _appointmentData;

  // List<AppointmentData> _filteredList = List<AppointmentData>();

  AppointmentList(this._appointmentData) {
/*    _appointmentData.forEach((element) {
      if (element.statusKey != 3) {
        _filteredList.add(element);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.only(left: mWidth * 0.01),
        child: LayoutBuilder(
          builder: (context, constrains) {
            var height = constrains.maxHeight;
            var width = constrains.maxWidth;
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: _appointmentData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //TODO Appointment Date
                          Container(
                            width: width * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DaysNum(
                                  Txt: getMonth(_appointmentData[index]
                                      .dateSession
                                      .substring(5, 7)),
                                  Fsize: 10,
                                ),
                                DaysNum(
                                  Txt: _appointmentData[index]
                                      .dateSession
                                      .substring(8, 10),
                                  Fsize: 18,
                                ),
                              ],
                            ),
                          ),
                          //TODO Patient Data
                          Container(
                            width: width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DaysNum(
                                    Txt:
                                        '${ConstString.DoctorName}${_appointmentData[index].doctorName}',
                                    Fsize: 14,
                                    TxtColor: ConstStyles.ViewsBackGround),
                                DaysNum(
                                  Txt: _appointmentData[index].patientName,
                                  Fsize: 14,
                                ),
                                DaysNum(
                                  Txt: _appointmentData[index].patientPhone,
                                  Fsize: 14,
                                ),
                              ],
                            ),
                          ),
                          //TODO Time From
                          Container(
                            width: width * 0.15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DaysNum(
                                  Txt: convertTo12Hr(_appointmentData[index]
                                      .timeFrom
                                      .substring(0, 5)),
                                  Fsize: 14,
                                  TxtColor: ConstStyles.BlackBackGround,
                                ),
                                DaysNum(
                                  Txt: getAmPm(_appointmentData[index]
                                      .timeFrom
                                      .substring(0, 2)),
                                  Fsize: 14,
                                  TxtColor: ConstStyles.BlackBackGround,
                                ),
                              ],
                            ),
                          ),
                          //TODO Appointment Type
                          Container(
                              width: width * 0.25,
                              child: CustomSmallButton(
                                text: AppointmentStatus(
                                    _appointmentData[index].statusKey),
                                onClick: () {},
                                radius: 20,
                                fontSize: 12,
                                color: getStatusColor(
                                    _appointmentData[index].statusKey),
                              )),
                        ],
                      ),
                    ),
                    background: Container(
                      color: ConstStyles.FlatIconBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.01, right: width * 0.01),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              Txt: ConstString.UpdateAppointmentData,
                              color: ConstStyles.BaseBackGround,
                              size: 12,
                            ),
                            Icon(
                              Icons.edit,
                              color: ConstStyles.BaseBackGround,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      //TODO For Editing
                      showDialog(
                          context: context,
                          builder: (context) {
                            return EditAppointment(_appointmentData[index]);
                          });
                    },
                  );
                });
          },
        ));
  }

  String getMonth(month) {
    switch (month) {
      case '01':
        return 'Jun';
      case '02':
        return 'Feb';
      case '03':
        return 'Mar';
      case '04':
        return 'Apr';
      case '05':
        return 'May';
      case '06':
        return 'June';
      case '07':
        return 'July';
      case '08':
        return 'Aug';
      case '09':
        return 'Sep';
      case '10':
        return 'Oct';
      case '11':
        return 'Nov';
      case '12':
        return 'Dec';
    }
  }

  String getAmPm(time) {
    // print('$LOGD :: $time');
    if (int.parse(time) >= 12) {
      return 'Pm';
    } else {
      return 'Am';
    }
  }

  String convertTo12Hr(time) {
    DateTime date =
        DateFormat("h:mm").parse(time); // think this will work better for you
    print('$LOGD Time :: ${DateFormat('h:mm').format(date)} ---> $time');
    return DateFormat('h:mm').format(date);
  }

  String AppointmentStatus(status) {
    switch (status) {
      case 1:
        return ConstString.New;
      case 2:
        return ConstString.Consultation;
      case 3:
        return ConstString.Cancel;
      case 4:
        return ConstString.Finish;
    }
  }

  Color getStatusColor(statusKey) {
    switch (statusKey) {
      case 1:
        return ConstStyles.NewStatus;
      case 2:
        return ConstStyles.ConsultationStatus;
      case 3:
        return ConstStyles.CancelStatus;
      case 4:
        return ConstStyles.FinishStatus;
    }
  }
}
