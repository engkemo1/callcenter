class AvailableTimesPerDayData {
  int key;
  String timeFrom;
  String timeTo;
  String day;
  String timeStatus;

  AvailableTimesPerDayData({this.key, this.timeFrom, this.timeTo, this.day, this.timeStatus});

  AvailableTimesPerDayData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    timeFrom = json['timeFrom'];
    timeTo = json['timeTo'];
    day = json['day'];
    timeStatus = json['timeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['timeFrom'] = this.timeFrom;
    data['timeTo'] = this.timeTo;
    data['day'] = this.day;
    data['timeStatus'] = this.timeStatus;
    return data;
  }
}