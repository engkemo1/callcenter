class OldChatsResData {
  int chatKey;
  String doctorName;
  int doctorId;
  String doctor_avatar;
  String last_message;
  var read;

  OldChatsResData({this.chatKey, this.doctorName, this.doctorId,this.read});

  OldChatsResData.fromJson(Map<String, dynamic> json) {
    chatKey = json['chat_key'];
    doctorName = json['doctor_name'];
    doctorId = json['doctor_id'];
    doctor_avatar = json['doctor_avatar'];
    last_message = json['last_message'];
    read = json['read'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_key'] = this.chatKey;
    data['doctor_name'] = this.doctorName;
    data['doctor_id'] = this.doctorId;
    data['doctor_avatar'] = this.doctor_avatar;
    data['last_message'] = this.last_message;
    data['read'] = this.read;

    return data;
  }
}