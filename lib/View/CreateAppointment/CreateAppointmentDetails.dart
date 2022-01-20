import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsController.dart';
import 'package:e7gz_call_center/Controller/CreateAppointment/CreateDetailsAppointmentController.dart';
import 'package:e7gz_call_center/Model/CreateAppointment/CreateAppointmentReq.dart';
import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocList.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/AvailableTimes/AvailableTimesList.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomFormFiled.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/ShowFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CreateAppointmentDetails extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FilteredDocList _appointmentData;
  CreateDetailsAppointmentController controller ;
  AllDoctorsController _allDoctorsController = Get.put(AllDoctorsController());


  CreateAppointmentDetails(this._appointmentData){
    controller = Get.put(CreateDetailsAppointmentController(_appointmentData.doctorKey));
    if(controller.dateSession !=null){
      controller.dateSession = null;
    }
    controller.currentDate = _allDoctorsController.currentDate;
    controller.getAvailableTime(controller.currentDate);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: GetBuilder<CreateDetailsAppointmentController>(
        builder: (_) {
          return ModalProgressHUD(
            inAsyncCall:
            controller.modalHudController.isLoading,
            child: Container(
              width: width ,
              height: height * 0.9,
              child: Form(
                key: _formKey,
                child: ListView(
                  // fit: StackFit.expand,
                  children: [
                    //TODO Date
                    Container(
                      width: width,
                      child: LayoutBuilder(
                        builder: (context,constrains){
                          var localHeight = constrains.maxHeight;
                          var localWidth = constrains.maxWidth;
                          return Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: localWidth / 4,
                                child: CustomText(
                                  Txt: ConstString.ChooseDate,
                                  alignText: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: localWidth /1.7,
                                child: ShowFormFiled(
                                  enabled: false,
                                  keybord: TextInputType.number,
                                  // data: controller.currentDate,
                                  myController: TextEditingController(
                                      text: controller
                                          .dateSession ==
                                          null
                                          ? controller
                                          .currentDate
                                          : controller
                                          .dateSession),
                                  onSave: (s) {
                                  },
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                width: localWidth / 9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ConstStyles.ViewsBackGround),
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: ConstStyles.BaseBackGround,
                                  ),
                                  onTap: () {
                                    controller
                                        .selectDate(context);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Center(
                      child: CustomText(
                        Txt: controller
                            .selectedWeekDay ==
                            null
                            ? ''
                            : controller
                            .selectedWeekDay,
                        size: 16,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),

                    //TODO Times List
                    Container(
                      width: width,
                      height: height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: AvailableTimesList(
                          controller
                              .availableTimes,_appointmentData.doctorKey),
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
                        ),
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
                                    patientPhone: controller.patientPhone, dateSession: controller.dateSession == null?controller.currentDate:controller.dateSession,
                                    time_key: controller.selectedTimeKey,status_key: controller.status_key);

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
            ),
          );
        },
      ),
    );
  }
}
