class ProfileEditResData {
  int key;
  String name;
  String email;
  String nationality;
  String iDNumber;
  String phone;
  String role;
  int shift;
  int bankAccount;
  String country;
  String governorate;
  String city;
  var registered;
  int status;
  String type;

  ProfileEditResData(
      {this.key,
        this.name,
        this.email,
        this.nationality,
        this.iDNumber,
        this.phone,
        this.role,
        this.shift,
        this.bankAccount,
        this.country,
        this.governorate,
        this.city,
        this.registered,
        this.status,
        this.type});

  ProfileEditResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    email = json['email'];
    nationality = json['nationality'];
    iDNumber = json['ID_number'];
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
    data['key'] = this.key;
    data['name'] = this.name;
    data['email'] = this.email;
    data['nationality'] = this.nationality;
    data['ID_number'] = this.iDNumber;
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