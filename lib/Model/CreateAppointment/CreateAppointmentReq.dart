class CreateAppointmentReq{
  String patientName;
  String patientPhone;
  String dateSession;
  int time_key;
  int status_key;

  CreateAppointmentReq(
      {this.patientName, this.patientPhone, this.dateSession, this.time_key,this.status_key});

  CreateAppointmentReq.fromJson(Map<String, dynamic> json) {
    patientName = json['patientName'];
    patientPhone = json['patientPhone'];
    dateSession = json['dateSession'];
    time_key = json['time_key'];
    status_key = json['status_key'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientName'] = this.patientName;
    data['patientPhone'] = this.patientPhone;
    data['dateSession'] = this.dateSession;
    data['time_key'] = this.time_key;
    data['status_key'] = this.status_key;
    return data;
  }
}