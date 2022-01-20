import 'package:e7gz_call_center/Model/Chat/ChatId/ChatIdResData.dart';

class ChatIdRes {
  ChatIdResData data;
  bool status;
  List<String> massage;

  ChatIdRes({this.data, this.status, this.massage});

  ChatIdRes.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ChatIdResData.fromJson(json['data']) : null;
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