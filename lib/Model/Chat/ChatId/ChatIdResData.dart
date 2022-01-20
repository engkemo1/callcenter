class ChatIdResData {
  int chatKey;

  ChatIdResData({this.chatKey});

  ChatIdResData.fromJson(Map<String, dynamic> json) {
    chatKey = json['chat_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_key'] = this.chatKey;
    return data;
  }
}