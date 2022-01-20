

import 'package:e7gz_call_center/Model/ShowAvailableTimes/AvailableTimesPerDayData.dart';

class AvailableTimes{
  AvailableTimesPerDayData _docAvailableTimesPerDayData;

  AvailableTimes({AvailableTimesPerDayData data}) : _docAvailableTimesPerDayData = data;

  int get key => _docAvailableTimesPerDayData.key;

  String get timeFrom => _docAvailableTimesPerDayData.timeFrom;

  String get timeStatus => _docAvailableTimesPerDayData.timeStatus;

  String get day => _docAvailableTimesPerDayData.day;

  String get timeTo => _docAvailableTimesPerDayData.timeTo;
}