import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocResData.dart';

class FilteredDocRes {
  List<FilteredDocResData> data;
  bool status;
  List<String> massage;

  FilteredDocRes({this.data, this.status, this.massage});

  FilteredDocRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FilteredDocResData>();
      json['data'].forEach((v) {
        data.add(new FilteredDocResData.fromJson(v));
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