
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableResData.dart';

class AppointmentTableRes {
  List<AppointmentTableResData> data;
  bool status;
  List<String> massage;

  AppointmentTableRes({this.data, this.status, this.massage});

  AppointmentTableRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AppointmentTableResData>();
      json['data'].forEach((v) {
        data.add(new AppointmentTableResData.fromJson(v));
      });
    }
    status = json['status'];
    massage = json['massage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['massage'] = this.massage;
    return data;
  }
}