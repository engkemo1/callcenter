class CloseChatRes {
  var data;
  bool status;
  List<String> massage;

  CloseChatRes({this.data, this.status, this.massage});

  CloseChatRes.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    status = json['status'];
    massage = json['massage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['status'] = this.status;
    data['massage'] = this.massage;
    return data;
  }
}