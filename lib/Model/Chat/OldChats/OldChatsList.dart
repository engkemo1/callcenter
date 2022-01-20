import 'package:e7gz_call_center/Model/Chat/OldChats/OldChatsResData.dart';

class OldChatsList{
  OldChatsResData _allNotificationResData;

  OldChatsList({OldChatsResData data}) : _allNotificationResData = data;

  int get chatKey => _allNotificationResData.chatKey;

  String get doctorName => _allNotificationResData.doctorName;

  int get doctorId => _allNotificationResData.doctorId;

  String get doctorAvatar => _allNotificationResData.doctor_avatar;

  String get lastMessage => _allNotificationResData.last_message;

  int get read => _allNotificationResData.read;

}