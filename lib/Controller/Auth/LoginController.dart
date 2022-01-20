import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/Login/LoginDocRes.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController{
  String email, password;
  String LOGD = '//LoginController';
  var dio = Dio();
  final ModalHudController modalHudController = Get.put(ModalHudController());
  final getStorage = GetStorage();

  Future<LoginDocRes> loginAuth() async {
    modalHudController.changeisLoading(true);
    update();
    var params = {
      'email': email,
      'password': password,
    };
    var  response;
    LoginDocRes loginDocRes;
    try {
      response = await dio
          .post(
        EndPoints.LoginEndPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
        data: jsonEncode(params),
      );
      loginDocRes = LoginDocRes.fromJson(response.data);
      print('$LOGD LoginDocRes:MSG: ${loginDocRes.massage[0]}');
      print('$LOGD Res=200:Response: ${jsonEncode(loginDocRes)})');
      if(loginDocRes.status && loginDocRes.data.roles == 'callCenter'){
        getStorage.write(ConstString.MyTokenKey, loginDocRes.data.accessToken);
        getStorage.write(ConstString.MyIdKey, loginDocRes.data.key);
        modalHudController.changeisLoading(false);
        update();
        Get.back();
        Get.offAllNamed('AllDoctors');
        return loginDocRes;
      }else{
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
            ConstString.ErrorOccurred, errorVaild(loginDocRes.massage[0]),
            backgroundColor: Colors.red[600],
            colorText: ConstStyles.BaseBackGround);
      }


    }on DioError catch (e) {
      modalHudController.changeisLoading(false);
      update();
      loginDocRes = LoginDocRes.fromJson(e.response.data);
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
      print('$LOGD catch:2: ${loginDocRes.massage.toString()} }');
      Get.snackbar(
          ConstString.ErrorOccurred, errorVaild(loginDocRes.massage[0]),
          backgroundColor: Colors.red[600],
          colorText: ConstStyles.BaseBackGround);
      return loginDocRes;
    }

  }

  //TODO Check Validation
  String errorVaild(res){
    switch(res){
      case 'The name field is required.':
        return ConstString.NameRequired;
      case   'The email has already been taken.' :
        return ConstString.EmailAlreadyExist ;
      case 'The email must be a valid email address.':
        return ConstString.UnValidEmail;
      case 'The password must be at least 6 characters.':
        return ConstString.PasswordLessThan6 ;
      case 'The password confirmation does not match.':
        return ConstString.PasswordsDoNotMatch ;
      case 'The phone field is required.':
        return ConstString.PhoneRequired ;
      case 'The password or email is failed':
        return ConstString.WrongEmailOrPassword ;
    }
  }

}