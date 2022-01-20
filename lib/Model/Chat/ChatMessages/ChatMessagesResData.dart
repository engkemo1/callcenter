class ChatMessagesResData {
  int key;
  String message;
  int senderKey;
  String sendDate;
  String sendTime;

  ChatMessagesResData({this.key, this.message, this.senderKey, this.sendDate, this.sendTime});

  ChatMessagesResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    message = json['message'];
    senderKey = json['sender_key'];
    sendDate = json['send_date'];
    sendTime = json['send_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['message'] = this.message;
    data['sender_key'] = this.senderKey;
    data['send_date'] = this.sendDate;
    data['send_time'] = this.sendTime;
    return data;
  }
}