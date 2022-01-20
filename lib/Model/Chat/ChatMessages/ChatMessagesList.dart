import 'package:e7gz_call_center/Model/Chat/ChatMessages/ChatMessagesResData.dart';

class ChatMessagesList{
  ChatMessagesResData _allNotificationResData;

  ChatMessagesList({ChatMessagesResData data}) : _allNotificationResData = data;

  int get key => _allNotificationResData.key;

  String get message => _allNotificationResData.message;

  int get senderKey => _allNotificationResData.senderKey;

  String get sendDate => _allNotificationResData.sendDate;

  String get sendTime => _allNotificationResData.sendTime;
}