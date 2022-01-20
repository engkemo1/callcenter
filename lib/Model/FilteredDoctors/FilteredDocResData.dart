class FilteredDocResData {
  int key;
  int doctorKey;
  String timeFrom;
  String timeTo;
  String doctorName;
  dynamic address;
  dynamic country;
  dynamic governorate;
  dynamic city;
  int department;
  var avatar;
  int price;


  FilteredDocResData(
      {this.key,
        this.doctorKey,
        this.timeFrom,
        this.timeTo,
        this.doctorName,
        this.address,
        this.country,
        this.governorate,
        this.city,
        this.department,
      this.avatar,this.price,});

  FilteredDocResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    doctorKey = json['doctor_key'];
    timeFrom = json['timeFrom'];
    timeTo = json['timeTo'];
    doctorName = json['doctorName'];
    address = json['address'];
    country = json['country'];
    governorate = json['governorate'];
    city = json['city'];
    department = json['department'];
    avatar = json['avatar'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['doctor_key'] = this.doctorKey;
    data['timeFrom'] = this.timeFrom;
    data['timeTo'] = this.timeTo;
    data['doctorName'] = this.doctorName;
    data['address'] = this.address;
    data['country'] = this.country;
    data['governorate'] = this.governorate;
    data['city'] = this.city;
    data['department'] = this.department;
    data['avatar'] = this.avatar;
    data['price'] = this.price;

    return data;
  }
}