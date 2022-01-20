import 'package:e7gz_call_center/Model/Chat/SendMessage/SendMessageResData.dart';

class SendMessageRes {
  SendMessageResData data;
  bool status;
  List<String> massage;

  SendMessageRes({this.data, this.status, this.massage});

  SendMessageRes.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SendMessageResData.fromJson(json['data']) : null;
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
