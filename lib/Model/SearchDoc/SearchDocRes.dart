import 'package:e7gz_call_center/Model/SearchDoc/SearchDocResData.dart';

class SearchDocRes {
  List<SearchDocResData> data;
  bool status;
  List<String> massage;

  SearchDocRes({this.data, this.status, this.massage});

  SearchDocRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SearchDocResData>();
      json['data'].forEach((v) {
        data.add(new SearchDocResData.fromJson(v));
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