class AllNotifyChatResData {
  int notifyKey;
  String notifyMessage;
  int messageKey;
  int userSender;
  int userRecipient;

  AllNotifyChatResData(
      {this.notifyKey,
        this.notifyMessage,
        this.messageKey,
        this.userSender,
        this.userRecipient});

  AllNotifyChatResData.fromJson(Map<String, dynamic> json) {
    notifyKey = json['notify_key'];
    notifyMessage = json['notify_message'];
    messageKey = json['message_key'];
    userSender = json['user_sender'];
    userRecipient = json['user_recipient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notify_key'] = this.notifyKey;
    data['notify_message'] = this.notifyMessage;
    data['message_key'] = this.messageKey;
    data['user_sender'] = this.userSender;
    data['user_recipient'] = this.userRecipient;
    return data;
  }
}