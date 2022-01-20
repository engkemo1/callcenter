import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocResData.dart';

class FilteredDocList{

  FilteredDocResData _docResData;

  FilteredDocList({FilteredDocResData data}) : _docResData = data;


  int get key => _docResData.key;

  int get doctorKey => _docResData.doctorKey;

  String get timeFrom => _docResData.timeFrom;

  String get timeTo => _docResData.timeTo;

  String get doctorName => _docResData.doctorName;

  dynamic get address => _docResData.address;

  dynamic get country => _docResData.country;

  dynamic get governorate => _docResData.governorate;

  dynamic get city => _docResData.city;

  int get department => _docResData.department;

  int get price => _docResData.price;
  String get avatar => _docResData.avatar;

}