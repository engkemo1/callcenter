class SendMessageResData {
  String message;
  int senderKey;

  SendMessageResData({this.message, this.senderKey});

  SendMessageResData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderKey = json['sender_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['sender_key'] = this.senderKey;
    return data;
  }
}