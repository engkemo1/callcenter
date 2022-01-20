class ChatMessagePusherRes{
  int senderKey;
  String message;
  int chatKey;

  ChatMessagePusherRes({this.senderKey, this.message,this.chatKey});

  ChatMessagePusherRes.fromJson(Map<String, dynamic> json) {
    senderKey = json['sender_key'];
    message = json['message'];
    chatKey = json['chat_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_key'] = this.senderKey;
    data['message'] = this.message;
    data['chat_key'] = this.chatKey;
    return data;
  }

}