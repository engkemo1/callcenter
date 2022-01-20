import 'package:e7gz_call_center/Model/SearchDoc/SearchDocResData.dart';

class SearchDocList{
  SearchDocResData _docResData;

  SearchDocList({SearchDocResData data}) : _docResData = data;
  int get key => _docResData.key;
  String get name => _docResData.name;
  String get email => _docResData.email;
  String get phone => _docResData.phone;
  int get iDNumber => _docResData.iDNumber;
  String get nationality => _docResData.nationality;
  String get avatar => _docResData.avatar;
  String get country => _docResData.country;
  String get government => _docResData.governorate;
  String get city => _docResData.city;
  String get address => _docResData.address;
  String get clinicName => _docResData.clinicName;
  dynamic get department => _docResData.department;
  int get sessionLength => _docResData.sessionLength;
  int get minPatient => _docResData.minPatient;
  int get maxPatient => _docResData.maxPatient;
  int get average => _docResData.average;
  int get price => _docResData.price;
  dynamic get registered => _docResData.registered;
  String get type => _docResData.type;
  int get doctorStatus => _docResData.doctorStatus;
  String get role => _docResData.role;

}