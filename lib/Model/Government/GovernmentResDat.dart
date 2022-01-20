class GovernmentResData {
  int key;
  String name;
  String country;

  GovernmentResData({this.key, this.name, this.country});

  GovernmentResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['country'] = this.country;
    return data;
  }
}