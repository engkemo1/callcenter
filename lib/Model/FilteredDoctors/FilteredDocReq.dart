class FilteredDocReq{
  String date;
  int user_id;
  int department;
  String governorate;
  String city;



  FilteredDocReq({
    this.date,
    this.user_id,
    this.department,
    this.governorate,
    this.city,
  });

  FilteredDocReq.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    user_id = json['user_id'];
    department = json['department'];
    governorate = json['governorate'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['user_id'] = this.user_id;
    data['department'] = this.department;
    data['governorate'] = this.governorate;
    data['city'] = this.city;
    return data;
  }
}