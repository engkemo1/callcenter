import 'package:e7gz_call_center/Model/Chat/ChatMessages/ChatMessagesResData.dart';

class ChatMessagesRes {
  List<ChatMessagesResData> data;
  bool status;
  List<String> massage;

  ChatMessagesRes({this.data, this.status, this.massage});

  ChatMessagesRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ChatMessagesResData>();
      json['data'].forEach((v) {
        data.add(new ChatMessagesResData.fromJson(v));
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