
import 'package:e7gz_call_center/Model/Country/CountryResData.dart';

class CountryRes {
  List<CountryResData> data;
  bool status;
  List<String> massage;

  CountryRes({this.data, this.status, this.massage});

  CountryRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CountryResData>();
      json['data'].forEach((v) {
        data.add(new CountryResData.fromJson(v));
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