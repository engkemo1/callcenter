import 'package:e7gz_call_center/Model/Specialist/SpecialistResData.dart';

class SpecialistList {
  SpecialistResData _specialistResData;

  SpecialistList({SpecialistResData data}) : _specialistResData = data;



  int get key => _specialistResData.key;

  String get name => _specialistResData.name;

  Null get desc => _specialistResData.desc;
}