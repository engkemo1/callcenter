class PusherNotificationRes {
  int notifyKey;
  String notifyMessage;
  var date;
  int userSender;
  int userRecipient;

  PusherNotificationRes(
      {this.notifyKey,
        this.notifyMessage,
        this.date,
        this.userSender,
        this.userRecipient});

  PusherNotificationRes.fromJson(Map<String, dynamic> json) {
    notifyKey = json['notify_key'];
    notifyMessage = json['notify_message'];
    date = json['date'];
    userSender = json['user_sender'];
    userRecipient = json['user_recipient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notify_key'] = this.notifyKey;
    data['notify_message'] = this.notifyMessage;
    data['date'] = this.date;
    data['user_sender'] = this.userSender;
    data['user_recipient'] = this.userRecipient;
    return data;
  }
  
}