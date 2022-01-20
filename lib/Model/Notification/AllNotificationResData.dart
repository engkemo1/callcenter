class AllNotificationResData {
  int notifyKey;
  String notifyMessage;
  String date;
  int userSender;
  var userRecipient;
  String status;
  String createAt;

  AllNotificationResData(
      {this.notifyKey,
        this.notifyMessage,
        this.date,
        this.userSender,
        this.userRecipient,
        this.status,
        this.createAt});

  AllNotificationResData.fromJson(Map<String, dynamic> json) {
    notifyKey = json['notifyKey'];
    notifyMessage = json['notifyMessage'];
    date = json['date'];
    userSender = json['userSender'];
    userRecipient = json['userRecipient'];
    status = json['status'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notifyKey'] = this.notifyKey;
    data['notifyMessage'] = this.notifyMessage;
    data['date'] = this.date;
    data['userSender'] = this.userSender;
    data['userRecipient'] = this.userRecipient;
    data['status'] = this.status;
    data['create_at'] = this.createAt;
    return data;
  }
}