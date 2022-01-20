
import 'package:e7gz_call_center/Model/Government/GovernmentResDat.dart';

class GovernmentRes {
  List<GovernmentResData> data;
  bool status;
  List<String> massage;

  GovernmentRes({this.data, this.status, this.massage});

  GovernmentRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<GovernmentResData>();
      json['data'].forEach((v) {
        data.add(new GovernmentResData.fromJson(v));
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