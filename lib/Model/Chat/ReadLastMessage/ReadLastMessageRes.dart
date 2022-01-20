class ReadLastMessageRes {
  var data;
  bool status;
  List<String> massage;

  ReadLastMessageRes({this.data, this.status, this.massage});

  ReadLastMessageRes.fromJson(Map<String, dynamic> json) {
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