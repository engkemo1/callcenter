class AppointmentsReq{
var date;
var doctor_key;
var callCenter_key;
var notify_key;

AppointmentsReq({
      this.date, this.doctor_key, this.callCenter_key, this.notify_key});

AppointmentsReq.fromJson(Map<String, dynamic> json) {
  date = json['date'];
  doctor_key = json['doctor_key'];
  callCenter_key = json['callCenter_key'];
  notify_key = json['notify_key'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['date'] = this.date;
  data['doctor_key'] = this.doctor_key;
  data['callCenter_key'] = this.callCenter_key;
  data['notify_key'] = this.notify_key;
  return data;
}
}