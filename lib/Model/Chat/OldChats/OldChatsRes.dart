import 'package:e7gz_call_center/Model/Chat/OldChats/OldChatsResData.dart';

class OldChatsRes {
  List<OldChatsResData> data;
  bool status;
  List<String> massage;

  OldChatsRes({this.data, this.status, this.massage});

  OldChatsRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<OldChatsResData>();
      json['data'].forEach((v) {
        data.add(new OldChatsResData.fromJson(v));
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