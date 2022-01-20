import 'dart:async';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'as DotEnv;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_websocket_flutter/pusher.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {


  StreamController<String> _eventData = StreamController<String>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  Channel channel;

  String channelName = 'NotifyCallcenter';
  String eventName = 'NotifyCallcenter';

  List<String> messages = new List<String>();

  FlutterLocalNotificationsPlugin fltrNotification;

  Future<void> initPusher() async {
    await Pusher.init(
        DotEnv.env['PUSHER_APP_KEY'],
        PusherOptions(cluster: DotEnv.env['PUSHER_APP_CLUSTER']),
        enableLogging: true
    );

    Pusher.connect();

    channel = await Pusher.subscribe(channelName);

    channel.bind(eventName, (last) {
      final String data = last.data;
      _inEventData.add(data);
    });

    eventStream.listen((data) async {
      messages.add(data);
      _showNotification();
      print('TharwatTest :: $messages ${messages.length}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notify();
    initPusher();

  }

  @override
  void dispose() {
    Pusher.unsubscribe(channelName);
    channel.unbind(eventName);
    _eventData.close();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstStyles.ViewsBackGround,
      body: Center(
        // child: CustomHeadersTextWhite(Txt: messages[0],),
      ),
    );


  }

  notify(){
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await fltrNotification.show(
        0, "Task", "You created a Task",
        generalNotificationDetails, payload: "Task");
  }

}
