
import 'package:e7gz_call_center/Model/Appointments/DocAppointmentTableResData.dart';

class AppointmentData{
  AppointmentTableResData _docAppointmentTableResData;

AppointmentData({AppointmentTableResData data}) : _docAppointmentTableResData = data;


int get key => _docAppointmentTableResData.key;

String get patientName => _docAppointmentTableResData.patientName;

String get patientPhone => _docAppointmentTableResData.patientPhone;

String get dateSession => _docAppointmentTableResData.dateSession;

String get timeFrom => _docAppointmentTableResData.timeFrom;

String get timeTo => _docAppointmentTableResData.timeTo;

int get statusKey => _docAppointmentTableResData.statusKey;

String get bookedBy => _docAppointmentTableResData.bookedBy;

int get doctor_key => _docAppointmentTableResData.doctor_key;

String get doctorName => _docAppointmentTableResData.doctorName;

String get address => _docAppointmentTableResData.address;

String get country => _docAppointmentTableResData.country;

String get governorate => _docAppointmentTableResData.governorate;

String get city => _docAppointmentTableResData.city;
}