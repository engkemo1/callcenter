
import 'package:e7gz_call_center/Model/Login/LoginDocResData.dart';

class LoginDocRes {
  LoginDocResData data;
  bool status;
  List<String> massage;

  LoginDocRes({this.data, this.status, this.massage});

  LoginDocRes.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LoginDocResData.fromJson(json['data']) : null;
    status = json['status'];
    massage = json['massage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    data['massage'] = this.massage;
    return data;
  }
}