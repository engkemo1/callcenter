import 'package:e7gz_call_center/Model/Chat/AllNotifyChatResData.dart';

class AllNotifyChatList{
  AllNotifyChatResData _allNotificationResData;

  AllNotifyChatList({AllNotifyChatResData data}) : _allNotificationResData = data;

  int get notifyKey => _allNotificationResData.notifyKey;

  String get notifyMessage => _allNotificationResData.notifyMessage;

  int get messageKey => _allNotificationResData.messageKey;

  int get userSender => _allNotificationResData.userSender;

  int get userRecipient => _allNotificationResData.userRecipient;


}