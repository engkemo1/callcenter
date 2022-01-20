class SearchDocResData {
  int key;
  String name;
  String email;
  String phone;
  int iDNumber;
  String nationality;
  String avatar;
  String country;
  String governorate;
  String city;
  String address;
  String clinicName;
  dynamic department;
  int sessionLength;
  int minPatient;
  int maxPatient;
  int average;
  int price;
  String registered;
  String type;
  int doctorStatus;
  String role;

  SearchDocResData(
      {this.key,
        this.name,
        this.email,
        this.phone,
        this.iDNumber,
        this.nationality,
        this.avatar,
        this.country,
        this.governorate,
        this.city,
        this.address,
        this.clinicName,
        this.department,
        this.sessionLength,
        this.minPatient,
        this.maxPatient,
        this.average,
        this.price,
        this.registered,
        this.type,
        this.doctorStatus,
        this.role});

  SearchDocResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    iDNumber = json['ID_number'];
    nationality = json['nationality'];
    avatar = json['avatar'];
    country = json['country'];
    governorate = json['governorate'];
    city = json['city'];
    address = json['address'];
    clinicName = json['clinicName'];
    department = json['department'];
    sessionLength = json['sessionLength'];
    minPatient = json['minPatient'];
    maxPatient = json['maxPatient'];
    average = json['average'];
    price = json['price'];
    registered = json['registered'];
    type = json['type'];
    doctorStatus = json['doctorStatus'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['ID_number'] = this.iDNumber;
    data['nationality'] = this.nationality;
    data['avatar'] = this.avatar;
    data['country'] = this.country;
    data['governorate'] = this.governorate;
    data['city'] = this.city;
    data['address'] = this.address;
    data['clinicName'] = this.clinicName;
    data['department'] = this.department;
    data['sessionLength'] = this.sessionLength;
    data['minPatient'] = this.minPatient;
    data['maxPatient'] = this.maxPatient;
    data['average'] = this.average;
    data['price'] = this.price;
    data['registered'] = this.registered;
    data['type'] = this.type;
    data['doctorStatus'] = this.doctorStatus;
    data['role'] = this.role;
    return data;
  }
}