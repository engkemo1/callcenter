class ChatPusherNotifyRes{
  int notifyKey;
  String notifyMessage;
  int message_key;
  int user_sender;

  ChatPusherNotifyRes({
      this.notifyKey, this.notifyMessage, this.message_key, this.user_sender});

  ChatPusherNotifyRes.fromJson(Map<String, dynamic> json) {
    notifyKey = json['notify_key'];
    notifyMessage = json['notify_message'];
    message_key = json['message_key'];
    user_sender = json['user_sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notify_key'] = this.notifyKey;
    data['notify_message'] = this.notifyMessage;
    data['message_key'] = this.message_key;
    data['user_sender'] = this.user_sender;
    return data;
  }

}