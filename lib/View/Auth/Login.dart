import 'package:e7gz_call_center/Controller/Auth/LoginController.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomFormFiled.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersText.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends GetView<LoginController> {
  String LOGD = '/LoginScreen';
  final ModalHudController _modalHudController = Get.put(ModalHudController());
  final _formKey = GlobalKey<FormState>();
  final LoginController _controller = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ConstStyles.BaseBackGround,
      body: SafeArea(
          child: GetBuilder<ModalHudController>(
            builder: (_){
              return ModalProgressHUD(
                inAsyncCall: _controller.modalHudController.isLoading,
                child: Padding(
                  padding: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
                  child: Container(
                    width: width,
                    height: height,
                    child:ListView(
                      children: [
                        //TODO Logo
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomHeadersText(Txt: ConstString.Welcome),
                                CustomHeadersText(Txt: ConstString.AppName),
                                CustomText(Txt: ConstString.SignIn),
                              ],
                            ),
                            Container(
                                width: width * 0.4,
                                child: Image(
                                  image: AssetImage('assets/images/logo.png'),
                                ))
                          ],
                        ),

                        //TODO Login Data
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Container(
                          height: height*0.5,
                          width: width,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(Txt: ConstString.Email,size: 17,),
                                CustomFormField(
                                  keybord: TextInputType.emailAddress,
                                  hint: ConstString.Email,
                                  onValidate:(value) => value.trim().isNotEmpty ? null : "Email Can't be Empty" ,
                                  onSave: (value) {
                                    _controller.email = value;
                                    print('$LOGD : save email :: ${_controller.email}');
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                CustomText(Txt: ConstString.Password,size: 17,),
                                CustomFormField(
                                  obscureText: true,
                                  hint: ConstString.Password,
                                  onSave: (value) {
                                    _controller.password = value;
                                    print('$LOGD : save Password :: ${_controller.password}');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        //TODO Login Button
                        SizedBox(
                          height: height * 0.02,
                        ),
                        CustomButton(text: ConstString.SignIn, onClick: ()async{
                          _modalHudController.changeisLoading(true);
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            print('$LOGD : save Login :: ${_controller.email}');
                            await _controller.loginAuth();
                          }else{
                            // print('$LoginDoctor : Invalid Data');
                          }
                        }),

                      ],
                    ),
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}
