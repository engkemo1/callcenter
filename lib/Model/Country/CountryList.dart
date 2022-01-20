

import 'package:e7gz_call_center/Model/Country/CountryResData.dart';

class CountryList{
  CountryResData _countryResData;

  CountryList({CountryResData data}) : _countryResData = data;

  int get key => _countryResData.key;

  String get name => _countryResData.name;
}