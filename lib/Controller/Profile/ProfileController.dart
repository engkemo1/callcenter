import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e7gz_call_center/Controller/ModalHudController.dart';
import 'package:e7gz_call_center/Model/City/CityList.dart';
import 'package:e7gz_call_center/Model/City/CityRes.dart';
import 'package:e7gz_call_center/Model/City/CityResData.dart';
import 'package:e7gz_call_center/Model/Country/CountryList.dart';
import 'package:e7gz_call_center/Model/Country/CountryRes.dart';
import 'package:e7gz_call_center/Model/Country/CountryResData.dart';
import 'package:e7gz_call_center/Model/Government/GovernmentList.dart';
import 'package:e7gz_call_center/Model/Government/GovernmentRes.dart';
import 'package:e7gz_call_center/Model/Government/GovernmentResDat.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileEditReq.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileEditRes.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileEditResData.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileRes.dart';
import 'package:e7gz_call_center/Model/Profile/ProfileResData.dart';
import 'package:e7gz_call_center/Model/Specialist/SpecialistList.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController{
  String LOGD = '/ProfileController';
  final getStorage = GetStorage();
  var dio = Dio();
  final ModalHudController modalHudController = Get.put(ModalHudController());
  var keyId, token;

  ProfileResData infoResData = ProfileResData();
  // DocProfileEditResData editResData = DocProfileEditResData();
  TextEditingController name = TextEditingController();
  // List<SpecialistList> specialistDataList = List<SpecialistList>();
  List<GovernmentList> governmentDataList = List<GovernmentList>();
  List<CityList> citiesDataList = List<CityList>();
  List<CountryList> countryDataList = List<CountryList>();

  String email;
  String ID_number;
  String phone;
  String nationality;
  String country;
  String governate;
  String city;
  String shift;

  var stringIdNumber,stringPhone;

  String  newDepartment,newCountry;
  String newCity,newGovernment;

  @override
  void onInit() async{
    keyId =getStorage.read(ConstString.MyIdKey).toString();
    token =  getStorage.read(ConstString.MyTokenKey);
    infoResData = await getProfileData();
    update();
    await getAllCountries();
    await getAllGovernment().whenComplete(() {
      if(newGovernment!=null){
        getAllCities(getGovId(newGovernment));
      }
    });
    update();
  }

  Future<ProfileResData> getProfileData() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.ShowProfileData +
        '/'+keyId +
        '?token='+token;
    print('$LOGD :URL: $Url');
    var response;
    ProfileRes docProfileInfoRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      docProfileInfoRes = ProfileRes.fromJson(response.data);
      print(
          '$LOGD docProfileInfoRes:Json: ${docProfileInfoRes.toJson()}');
      if (docProfileInfoRes.status) {
        modalHudController.changeisLoading(false);
        infoResData = ProfileResData.fromJson(docProfileInfoRes.data.toJson());
        if(infoResData.iDNumber!=null){
          stringIdNumber = infoResData.iDNumber.toString();
        }
        if(infoResData.phone!=null){
          stringPhone = infoResData.phone.toString();
        }
        newCity = infoResData.city;
        newCountry = infoResData.country;
        print('$LOGD infoResData:: ${city}');
        if(infoResData.governorate!=null){
          newGovernment = infoResData.governorate;
        }
        update();
        // getAllCities(getGovId(newGovernment));
        return infoResData;
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      update();
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
    }
  }

  changeGovernment(value){
    newCity = null;
    newGovernment = value;
    governate = newGovernment;
    update();
    getAllCities(getGovId(newGovernment));
    update();
  }

  changeCountry(value){
    newCountry = value;
    update();
  }

  changeCity(value){
    newCity = value;
    city = newCity;
    update();
  }

  ProfileEditReq prepareData(){
    if(city == null){
      city = infoResData.city;
    }
    if(governate == null){
      governate = infoResData.governorate;
    }
    if(ID_number == null){
      ID_number = infoResData.iDNumber;
    }
    if(nationality == null){
      nationality = infoResData.nationality;
    }
    return ProfileEditReq(name: infoResData.name,email: infoResData.email,phone: phone,
        ID_number: ID_number,city:city,governorate: governate,country: country,bankAccount: null,nationality: nationality,
        shift: shift,registered: null,role: null,status: null,type: null,);
  }

  Future<ProfileEditResData> editProfileData() async {
    ProfileEditReq docProfileEdit = prepareData();
    print('$LOGD edit Doc Req :Json: ${jsonEncode(docProfileEdit)}');

    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.EditProfileData +
        '/'+keyId +
        '?token='+token;
    print('$LOGD :URL: $Url');
    var response;
    ProfileEditRes docProfileEditRes;
    try {
      response = await dio.put(
          Url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
          }),
          data:jsonEncode(docProfileEdit)
      );
      docProfileEditRes = ProfileEditRes.fromJson(response.data);
      print('$LOGD doc  Edit Res:Json: ${docProfileEditRes.toJson()}');
      if (docProfileEditRes.status) {
        // infoResData = DocProfileEditRes.fromJson(docProfileEditRes.data.toJson());
        infoResData = await getProfileData();
        print('$LOGD Doc Res Info Data:: ${infoResData.key}');
        modalHudController.changeisLoading(false);
        update();
        // return infoResData;
      }
    } on DioError catch (e) {
      getProfileData();
      modalHudController.changeisLoading(false);
      update();
      print('$LOGD catch:1: ${e} ');
    }
  }

  Future<List<CountryResData>> getAllCountries() async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetAllCountries + token;
    print('$LOGD :URL: $Url');
    var response;
    CountryRes countryRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      countryRes = CountryRes.fromJson(response.data);
      print(
          '$LOGD countryRes:Json:  -----> ${countryRes.data.length} ');
      if (countryRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<CountryResData> countryResData =
        List<CountryResData>.from(
            list.map((e) => CountryResData.fromJson(e)).toList());
        // print('$LOGD appointmentData::: ${specialistResData.length}');
        // this.appointmentData = docAppointmentTableResData.map((e) => AppointmentData(data: e)).toList();
        if(countryResData.length > 0){
          this.countryDataList = countryResData.map((e) => CountryList(data: e)).toList();
          print('$LOGD countryResData::: ${citiesDataList.length}');
          modalHudController.changeisLoading(false);
          update();
          return countryResData;
        }else{
          modalHudController.changeisLoading(false);
          print('$LOGD No Data000 :: ${countryRes.massage}');
          update();
          Get.snackbar(
            '', ConstString.ErrorOccurred,
            backgroundColor: ConstStyles.TextBackGround,
            colorText: ConstStyles.BaseBackGround,
            messageText: CustomHeadersTextWhite(Txt: ConstString.ErrorOccurred),
          );
          return countryResData;
        }
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.ErrorOccurred,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.ErrorOccurred),
        );
        print('$LOGD No Data :: ${countryRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      countryRes = CountryRes.fromJson(response.data);
      this.countryDataList = null;
      update();
      Get.snackbar(
        '', ConstString.ErrorOccurred,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.ErrorOccurred),
      );
      print('$LOGD catch:1: ${jsonEncode(e.response.data)} ');
      // print('$LOGD catch:2: ${docAppointmentTableRes.massage.toString()} }');
      // Get.snackbar(
      //     ConstString.ErrorOccurred, errorVaild(registerDocRes.massage[0]),
      //     backgroundColor: Colors.red[600],
      //     colorText: ConstStyles.BaseBackGround);
      // return docAppointmentTableResData;
    }
  }

  Future<List<GovernmentResData>> getAllGovernment() async {
    modalHudController.changeisLoading(true);

    update();
    var Url = EndPoints.GetAllGovernment + token;
    // print('$LOGD :URL: $Url');
    var response;
    GovernmentRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = GovernmentRes.fromJson(response.data);
      // print(
      //     '$LOGD specialistRes:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<GovernmentResData> specialistResData =
        List<GovernmentResData>.from(
            list.map((e) => GovernmentResData.fromJson(e)).toList());
        if(specialistResData.length > 0){
          this.governmentDataList = specialistResData.map((e) => GovernmentList(data: e)).toList();
          modalHudController.changeisLoading(false);
          // getAllCities(getGovId(newGovernment));
          update();
          return specialistResData;
        }
      }else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAvailableDoctors,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
        );
        // print('$LOGD No Data :: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = GovernmentRes.fromJson(response.data);
      this.governmentDataList = null;
      update();
      Get.snackbar(
        '', ConstString.NoAvailableDoctors,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        // titleText: CustomHeadersTextWhite(Txt: 'عفوا'),
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
      );
    }
  }

  int getGovId(name){
    // print('$LOGD Gov length --> ${governmentDataList.length} }');
    for(int i=0 ; i<=governmentDataList.length ; i++){
      // print('$LOGD Gov Name --> ${name}   ,  Gov List Name --> ${governmentDataList[i].name}');
      if(name == governmentDataList[i].name){
        return governmentDataList[i].key;
      }
    }
  }

  Future<List<CityResData>> getAllCities(govId) async {
    modalHudController.changeisLoading(true);
    update();
    var Url = EndPoints.GetCitiesByGov+'/' + govId.toString();
    // print('$LOGD getAllCities:URL: $Url');
    var response;
    CityRes specialistRes;

    try {
      response = await dio.get(
        Url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json charset=UTF-8",
        }),
      );
      specialistRes = CityRes.fromJson(response.data);
      // print(
      //     '$LOGD getAllCities:Json: ${specialistRes.toJson()} -----> ${specialistRes.data.length} ');
      if (specialistRes.status ) {
        final result = response.data;
        Iterable list =result['data'];
        List<CityResData> specialistResData =
        List<CityResData>.from(
            list.map((e) => CityResData.fromJson(e)).toList());
        print('$LOGD getAllCities::: ${specialistResData[0].governorate}');
        this.citiesDataList = specialistResData.map((e) => CityList(data: e)).toList();
          modalHudController.changeisLoading(false);
          update();
          return specialistResData;

      }
      else {
        modalHudController.changeisLoading(false);
        update();
        Get.snackbar(
          '', ConstString.NoAvailableDoctors,
          backgroundColor: ConstStyles.TextBackGround,
          colorText: ConstStyles.BaseBackGround,
          messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
        );
        // print('$LOGD No Data :: ${specialistRes.massage}');
      }
    } on DioError catch (e) {
      modalHudController.changeisLoading(false);
      specialistRes = CityRes.fromJson(response.data);
      this.citiesDataList = null;
      update();
      Get.snackbar(
        '', ConstString.NoAvailableDoctors,
        backgroundColor: ConstStyles.TextBackGround,
        colorText: ConstStyles.BaseBackGround,
        messageText: CustomHeadersTextWhite(Txt: ConstString.NoAvailableDoctors),
      );
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    // Get.back();
    // Get.reset();
    print('$LOGD :: closed');
    ID_number = null;
    super.onClose();
  }
}