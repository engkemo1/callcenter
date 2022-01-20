class ProfileEditReq {
  String name;
  String email;
  String nationality;
  String ID_number;
  String phone;
  String role;
  String shift;
  String bankAccount;
  String country;
  String governorate;
  String city;
  String registered;
  int status;
  String type;


  ProfileEditReq({
    this.name,
    this.email,
    this.nationality,
    this.ID_number,
    this.phone,
    this.role,
    this.shift,
    this.bankAccount,
    this.country,
    this.governorate,
    this.city,
    this.registered,
    this.status,
    this.type,});

  ProfileEditReq.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    email = json['email'];
    nationality = json['nationality'];
    ID_number = json['ID_number'];
    phone = json['phone'];
    role = json['role'];
    shift = json['shift'];
    bankAccount = json['bankAccount'];
    country = json['country'];
    governorate = json['governorate'];
    city = json['city'];
    registered = json['registered'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['nationality'] = this.nationality;
    data['ID_number'] = this.ID_number;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['shift'] = this.shift;
    data['bankAccount'] = this.bankAccount;
    data['country'] = this.country;
    data['governorate'] = this.governorate;
    data['city'] = this.city;
    data['registered'] = this.registered;
    data['status'] = this.status;
    data['type'] = this.type;
    return data;
  }
}