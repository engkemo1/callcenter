import 'package:e7gz_call_center/Model/City/CityResData.dart';

class CityList{

  CityResData _cityResData;

  CityList({CityResData data}) : _cityResData = data;

  int get key => _cityResData.key;

  String get name => _cityResData.name;

  String get governorate => _cityResData.governorate;
}