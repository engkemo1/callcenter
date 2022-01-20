import 'package:e7gz_call_center/Controller/Profile/ProfileController.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomProfileFormFiled.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/ShowFormFiled.dart';
import 'package:e7gz_call_center/View/MainDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Profile extends GetView<ProfileController> {
  String LOGD = '/ProfileScreen';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<ProfileController>(
      init: Get.put(ProfileController()),
      builder: (controller){
        print(controller.phone);
        return ModalProgressHUD(
          inAsyncCall: controller.modalHudController.isLoading,
          child: Scaffold(
            drawer: MainDrawer(),
            appBar: AppBar(
              title: CustomHeadersTextWhite(Txt: ConstString.Profile),
            ),
            body: Container(
              padding:
              EdgeInsets.only(right: width * 0.05, left: width * 0.05),
              child: Stack(
                children: [

                  //TODO Data
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          // color: ConstStyles.HeadersBackGround,
                          margin: EdgeInsets.only(bottom: height * 0.06),
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              children: [
                                //TODO Name
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                CustomText(
                                  Txt: ConstString.Name,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                ShowFormFiled(
                                  enabled: false,
                                  myController: TextEditingController(
                                      text:
                                      controller.infoResData.name),
                                  onSave: (s) {
                                    // controller.name =  TextEditingController(text: s);
                                    // print('$LOGD Name: ${s}');
                                    // _formKey.currentState.save();
                                  },
                                ),

                                //TODO Email
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(
                                  Txt: ConstString.Email,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                ShowFormFiled(
                                  enabled: false,
                                  keybord: TextInputType.emailAddress,
                                  myController: TextEditingController(
                                      text: controller
                                          .infoResData.email),
                                  onSave: (s) {
                                    // controller.email =
                                    //     controller.infoResData.email;
                                    // _registerDoctorController.email = s;
                                    // print('$LOGD Email: ${registerDocModelData.name}');
                                  },
                                ),

                                //TODO IdNumber
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(
                                  Txt: ConstString.IdNumber,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                CustomProfileFormFiled(
                                  keybord: TextInputType.number,
                                  enabled: true,
                                  myController: TextEditingController(
                                    text: controller.ID_number == null ?
                                        controller.stringIdNumber :
                                        controller.ID_number
                                  ),
/*                                  onSave: (s) {
                                    controller.ID_number = s;
                                    print('save');
                                  },*/
                                  onChange: (s){
                                  controller.ID_number = s;
                                  _formKey.currentState.save();
                                  },
                                ),

                                //TODO Phone
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(
                                  Txt: ConstString.Phone,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                CustomProfileFormFiled(
                                  keybord: TextInputType.number,
                                  myController: TextEditingController(
                                      text: controller.phone == null ? controller.stringPhone : controller.phone),
                                  // hint: controller.infoResData.phone,
/*                                  onSave: (s) {
                                    controller.phone = s;
                                  },*/
                                onChange: (s){
                                  controller.phone = s;
                                  _formKey.currentState.save();
                                },
                                ),

                                //TODO Nationality
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(
                                  Txt: ConstString.Nationality,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                CustomProfileFormFiled(
                                  myController: TextEditingController(
                                      text: controller
                                          .nationality == null ? controller.infoResData.nationality : controller.nationality),
/*                                  onSave: (s) {
                                    controller.nationality = s;
                                    print('save');
                                  },*/
                                onChange: (s){
                                  controller.nationality = s;
                                  _formKey.currentState.save();
                                },
                                ),

                                //TODO Country
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(
                                  Txt: ConstString.Country,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                DropdownButton(
                                  items: controller.countryDataList
                                      .map((appointmentType) {
                                    return DropdownMenuItem(
                                        value: appointmentType.name,
                                        child: Container(
                                          width: width * 0.8,
                                          child: CustomText(
                                            Txt: appointmentType.name,
                                            size: 16,
                                            color: ConstStyles
                                                .BlackBackGround,
                                          ),
                                        )

                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.changeCountry(value);
                                    for(int i=0;i<controller.countryDataList.length;i++){
                                      if(controller.countryDataList[i].name == value){
                                        controller.country = controller.countryDataList[i].name;
                                      }
                                    }

                                  },
                                  value: controller.newCountry,
                                  dropdownColor:
                                  ConstStyles.TextBackGround,
                                  icon: Icon(
                                      Icons.arrow_drop_down_circle),
                                  iconEnabledColor:
                                  ConstStyles.ViewsBackGround,
                                  elevation: 10,
                                ),

                                //TODO Government
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(
                                  Txt: ConstString.Government,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                DropdownButton(
                                  items: controller.governmentDataList
                                      .map((appointmentType) {
                                    return DropdownMenuItem(
                                        value: appointmentType.name,
                                        child: Container(
                                          width: width * 0.8,
                                          child: CustomText(
                                            Txt: appointmentType.name,
                                            size: 16,
                                            color: ConstStyles
                                                .BlackBackGround,
                                          ),
                                        )

                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.changeGovernment(value);
                                  },
                                  value: controller.newGovernment,
                                  dropdownColor:
                                  ConstStyles.TextBackGround,
                                  icon: Icon(
                                      Icons.arrow_drop_down_circle),
                                  iconEnabledColor:
                                  ConstStyles.ViewsBackGround,
                                  elevation: 10,
                                ),

                                //TODO City
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(
                                  Txt: ConstString.City,
                                  size: 17,
                                  alignText: TextAlign.start,
                                ),
                                DropdownButton(
                                  items: controller.citiesDataList
                                      .map((appointmentType) {
                                    return DropdownMenuItem(
                                        value: appointmentType.name,
                                        child: Container(
                                          width: width * 0.8,
                                          child: CustomText(
                                            Txt: appointmentType.name,
                                            size: 16,
                                            color: ConstStyles
                                                .BlackBackGround,
                                          ),
                                        )

                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.changeCity(value);
                                    // for(int i=0;i<controller.citiesDataList.length;i++){
                                    //   if(controller.citiesDataList[i].name == value){
                                    //     controller.city = controller.citiesDataList[i].name;
                                    //   }
                                    // }

                                  },
                                  value: controller.newCity,
                                  dropdownColor:
                                  ConstStyles.TextBackGround,
                                  icon: Icon(
                                      Icons.arrow_drop_down_circle),
                                  iconEnabledColor:
                                  ConstStyles.ViewsBackGround,
                                  elevation: 10,
                                ),

                                SizedBox(
                                  height: height * 0.03,
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),

                  //TODO Edit Btn
                  Positioned.fill(
                    child: Align(
                      widthFactor: width,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        // color: ConstStyles.BlackBackGround,
                          width: width,
                          height: height * 0.05,
                          child: CustomButton(
                              text: ConstString.Update,
                              onClick: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  print(
                                      '$LOGD Update Cliclked :: ${controller.name.text}');
                                  //TODO Edit
                                  await controller.editProfileData();
                                }
                              })),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
