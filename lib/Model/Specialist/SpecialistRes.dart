
import 'package:e7gz_call_center/Model/Specialist/SpecialistResData.dart';

class SpecialistRes {
  List<SpecialistResData> data;
  bool status;
  List<String> massage;

  SpecialistRes({this.data, this.status, this.massage});

  SpecialistRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SpecialistResData>();
      json['data'].forEach((v) {
        data.add(new SpecialistResData.fromJson(v));
      });
    }
    status = json['status'];
    massage = json['massage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['massage'] = this.massage;
    return data;
  }
}