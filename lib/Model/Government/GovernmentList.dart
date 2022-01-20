import 'package:e7gz_call_center/Model/Government/GovernmentResDat.dart';

class GovernmentList{
  GovernmentResData _governmentResData;

  GovernmentList({GovernmentResData data}) : _governmentResData = data;

  int get key => _governmentResData.key;

  String get name => _governmentResData.name;

  String get country => _governmentResData.country;
}