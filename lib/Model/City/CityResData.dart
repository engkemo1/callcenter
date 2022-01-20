class CityResData {
  int key;
  String name;
  String governorate;

  CityResData({this.key, this.name, this.governorate});

  CityResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    governorate = json['governorate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['governorate'] = this.governorate;
    return data;
  }
}