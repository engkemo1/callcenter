import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsController.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppointmentReq.dart';
import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocList.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomFormFiled.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CreateAppointment extends GetView<AllDoctorsController> {
  FilteredDocList _appointmentData;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateAppointment(this._appointmentData);

  @override
  Widget build(BuildContext context) {
    var Mheight = MediaQuery.of(context).size.height;
    var Mwidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: GetBuilder<AllDoctorsController>(
        init: Get.put(AllDoctorsController()),
        builder: (controller) {
          return ModalProgressHUD(
            inAsyncCall:
            controller.modalHudController.isLoading,
            child: Container(
              width: Mwidth * 0.8,
              height: Mheight * 0.6,
              child: LayoutBuilder(
                builder: (context,constrains){
                  var height = constrains.maxHeight;
                  var width = constrains.maxWidth;
                  return Container(
                    width: width ,
                    height: height,
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        // fit: StackFit.expand,
                        children: [
                          //TODO Date
                          Container(
                            width: width,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: width * 0.25,
                                    child: CustomText(Txt: ConstString.AppointmentDate,color: ConstStyles.BlackBackGround,)),
                                SizedBox(
                                  width: width * 0.25,
                                  child: CustomText(
                                    Txt: controller
                                        .selectedWeekDay
                                        ,
                                  ),
                                ),
                                SizedBox(
                                    width: width * 0.5,
                                    child: CustomText(Txt: controller.currentDate)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),

                          //TODO Appointment Time
                          Container(
                            width: width,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: width * 0.2,
                                    child: CustomText(Txt: ConstString.AppointmentTime,color: ConstStyles.BlackBackGround,)),
                                SizedBox(
                                    width: width * 0.35,
                                    child: CustomText(Txt: convertTo12Hr(_appointmentData.timeFrom))),
                                SizedBox(
                                    width: width * 0.1,
                                    child: CustomText(Txt: ' - ')),
                                SizedBox(
                                    width: width * 0.35,
                                    child: CustomText(Txt: convertTo12Hr(_appointmentData.timeTo))),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),

                          //TODO Patient Name
                          CustomText(
                            Txt: ConstString.PatientName,
                            size: 17,
                            alignText: TextAlign.start,
                          ),
                          CustomFormField(
                            hint: ConstString.PatientName,
                            onSave: (s) {
                              controller
                                  .patientName = s;
                              print(
                                  'LOGDPatientName: ${controller.patientName}');
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          //TODO Patient Phone
                          CustomText(
                            Txt: ConstString.PatientPhone,
                            size: 17,
                            alignText: TextAlign.start,
                          ),
                          CustomFormField(
                            keybord: TextInputType.phone,
                            hint: ConstString.PatientPhone,
                            onSave: (s) {
                              controller
                                  .patientPhone = s;
                              print(
                                  'LOGDPatientName: ${controller.patientPhone}');
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          //TODO Appointment Type
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              CustomText(
                                Txt: ConstString.AppointmentType,
                                size: 17,
                                alignText: TextAlign.start,
                              ),
                              DropdownButton(
                                items: ConstString.CreateAppointmentTypesList
                                    .map((appointmentType) {
                                  return DropdownMenuItem(
                                      value: appointmentType,
                                      child: CustomText(
                                        Txt: appointmentType,
                                        color: ConstStyles
                                            .BlackBackGround,
                                      )

                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller
                                      .changeAppointmentType(
                                      value);
                                },
                                value: controller
                                    .appointmentType,
                                dropdownColor:
                                ConstStyles.TextBackGround,
                                // focusColor: Colors.teal,
                                icon: Icon(
                                    Icons.arrow_drop_down_circle),
                                iconEnabledColor:
                                ConstStyles.ViewsBackGround,
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),

                          //TODO Save Button
                          Container(
                              width: width,
                              height: height * 0.04,
                              child: CustomButton(
                                  text: ConstString.Save,
                                  onClick: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      CreateAppointmentReq req = CreateAppointmentReq(patientName: controller.patientName,
                                          patientPhone: controller.patientPhone, dateSession: controller.currentDate,
                                          time_key: _appointmentData.key,status_key: controller.status_key);
                                      if (await controller
                                          .createAppointment(req)) {
                                        Navigator.pop(context);
                                        Get.snackbar(
                                            '', ConstString.AppointmentCreated,
                                            backgroundColor: ConstStyles.TextBackGround,
                                            colorText: ConstStyles.BaseBackGround,messageText: CustomHeadersTextWhite(Txt: ConstString.AppointmentCreated));

                                      }

                                    }
                                  }))
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          );
        },
      ),
    );
  }

  String convertTo12Hr(time){
    DateTime date = DateFormat("h:mm").parse(time); // think this will work better for you
    // print('$LOGD Time :: ${DateFormat('h:mm').format(date)} ---> $time');
    return DateFormat('h:mm a').format(date);
  }
}

