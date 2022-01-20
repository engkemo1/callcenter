class SpecialistResData {
  int key;
  String name;
  Null desc;

  SpecialistResData({this.key, this.name, this.desc});

  SpecialistResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['desc'] = this.desc;
    return data;
  }
}