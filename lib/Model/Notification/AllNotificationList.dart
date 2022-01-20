import 'package:e7gz_call_center/Model/Notification/AllNotificationResData.dart';

class AllNotificationList{
  AllNotificationResData _allNotificationResData;

  AllNotificationList({AllNotificationResData data}) : _allNotificationResData = data;

  int get notifyKey => _allNotificationResData.notifyKey;

  String get notifyMessage => _allNotificationResData.notifyMessage;

  String get createAt => _allNotificationResData.createAt;

  String get status => _allNotificationResData.status;

  get userRecipient => _allNotificationResData.userRecipient;

  int get userSender => _allNotificationResData.userSender;

  String get date => _allNotificationResData.date;
}