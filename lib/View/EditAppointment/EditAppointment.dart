import 'package:e7gz_call_center/Controller/EditAppointment/EditAppointmentController.dart';
import 'package:e7gz_call_center/Model/Appointments/AppointmentData.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/AvailableTimes/AvailableTimesListEdit.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomFormFiled.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/LogoContainer.dart';
import 'package:e7gz_call_center/View/CustomWidget/ShowFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditAppointment extends StatelessWidget {
  AppointmentData _oldAppointmentData;
  EditAppointmentController _appointmentController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditAppointment(this._oldAppointmentData){
    _appointmentController = Get.put(EditAppointmentController(_oldAppointmentData));
    _appointmentController.oldDate = _oldAppointmentData.dateSession;
    _appointmentController.oldDocKey = _oldAppointmentData.doctor_key;
    _appointmentController.getAvailableTime(_appointmentController.oldDate,_appointmentController.oldDocKey);
    _appointmentController.oldSelectedWeekDay =_appointmentController.getWeekDay(DateTime.parse(_appointmentController.oldDate).weekday);
    _appointmentController.oldPatientName = _oldAppointmentData.patientName;
    _appointmentController.oldPatientPhone = _oldAppointmentData.patientPhone;
    _appointmentController.oldStatus_key = _oldAppointmentData.statusKey;
    _appointmentController.oldAppointmentType = _appointmentController.getAppointmentTypeFromStatusKey(_appointmentController.oldStatus_key);
    _appointmentController.getAppointmentTypeFromStatusKey(_oldAppointmentData.statusKey);
    _appointmentController.oldAppointmentTimeFrom = _appointmentController.convertTo12Hr(_oldAppointmentData.timeFrom.substring(0,5));
    _appointmentController.oldAppointmentTimeTo = _appointmentController.convertTo12Hr(_oldAppointmentData.timeTo.substring(0,5));
  }

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: GetBuilder<EditAppointmentController>(
        builder: (_) {
          return ModalProgressHUD(
            inAsyncCall:
            _appointmentController.modalHudController.isLoading,
            child: Container(
              width: mWidth * 0.8,
              height: mHeight * 0.8,
              child: LayoutBuilder(builder: (context,constrains){
                var height = constrains.maxHeight;
                var width = constrains.maxWidth;
                return Container(
                  width: width,
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
                            MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.2,
                                child: CustomText(
                                  Txt: ConstString.ChooseDate,
                                  size: 14,
                                  alignText: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.6,
                                child: ShowFormFiled(
                                  enabled: false,
                                  keybord: TextInputType.number,
                                  // data: _appointmentController.currentDate,
                                  myController: TextEditingController(
                                      text: _appointmentController.oldDate),
                                  onSave: (s) {
                                    // print(
                                    // '$LOGD min :: $s');
                                    // _controller
                                    //     .minPatient =
                                    //     int.parse(s);
                                    // _formKey.currentState.save();
                                  },
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ConstStyles.ViewsBackGround),
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: ConstStyles.BaseBackGround,
                                  ),
                                  onTap: () {
                                    _appointmentController
                                        .selectDate(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomText(
                          Txt: _appointmentController.oldSelectedWeekDay,
                          size: 16,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        //TODO Times List
                        Container(
                          width: width,
                          height: height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: GetBuilder<EditAppointmentController>(
                              builder: (controller) {
                                if (_appointmentController
                                    .availableTimes !=
                                    null &&
                                    _appointmentController
                                        .availableTimes.length >
                                        0) {
                                  return AvailableTimesListEdit(
                                      controller
                                          .availableTimes,null);
                                } else {
                                  return Center(
                                    child: LogoContainer(),
                                  );
                                }
                              }),
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
                          myController: TextEditingController(text: _appointmentController.oldPatientName),
                          hint: ConstString.PatientName,
                          onSave: (s) {
                            _appointmentController
                                .oldPatientName = s;
                            print(
                                'LOGDPatientName: ${_appointmentController.oldPatientName}');
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
                          myController: TextEditingController(text: _appointmentController.oldPatientPhone),
                          keybord: TextInputType.phone,
                          hint: ConstString.PatientPhone,
                          onSave: (s) {
                            _appointmentController
                                .oldPatientPhone = s;
                            print(
                                'LOGDPatientName: ${_appointmentController.oldPatientPhone}');
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
                            GetBuilder<
                                EditAppointmentController>(
                                builder: (_) {
                                  return DropdownButton(
                                    items: ConstString.EditAppointmentTypesList
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
                                      _appointmentController
                                          .changeAppointmentType(
                                          value);
                                    },
                                    value: _appointmentController.oldAppointmentType,
                                    dropdownColor:
                                    ConstStyles.TextBackGround,
                                    // focusColor: Colors.teal,
                                    icon: Icon(
                                        Icons.arrow_drop_down_circle),
                                    iconEnabledColor:
                                    ConstStyles.ViewsBackGround,
                                    elevation: 10,
                                  );
                                })
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        //TODO old Appointment
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ConstStyles.HeadersBackGround,width: 2),
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: CustomText(
                                  Txt: ConstString.AppointmentOldTime,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(Txt: ConstString.From),
                                  CustomText(Txt: _appointmentController.oldAppointmentTimeFrom),
                                  CustomText(Txt: ConstString.To),
                                  CustomText(Txt: _appointmentController.oldAppointmentTimeTo),
                                ],
                              ),
                            ],
                          ),
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
                                    if(_appointmentController.availableTimes != null){
                                      if (await _appointmentController
                                          .docEditAppointment(_oldAppointmentData.key)) {
                                        Navigator.pop(context);
                                      }
                                    }else{
                                      Get.snackbar(
                                          ConstString.ErrorOccurred, ConstString.PleaseSelectYourTime,
                                          backgroundColor: Colors.red[600],
                                          colorText: ConstStyles.BaseBackGround);
                                    }

                                  }
                                }))
                      ],
                    ),
                  ),
                );
              },)
            ),
          );
        },
      ),
    );
  }
}
