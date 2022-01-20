import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsBinding.dart';
import 'package:e7gz_call_center/Controller/Auth/LoginBinding.dart';
import 'package:e7gz_call_center/Controller/Chats/ChatsBinding.dart';
import 'package:e7gz_call_center/Controller/Profile/ProfileBinding.dart';
import 'package:e7gz_call_center/Controller/ShowMyAppointments/ShowMyAppointmentsBinding.dart';
import 'package:e7gz_call_center/View/AllDoctors/AllDoctors.dart';
import 'package:e7gz_call_center/View/Auth/Login.dart';
import 'package:e7gz_call_center/View/Auth/Profile.dart';
import 'package:e7gz_call_center/View/Chats/Chat.dart';
import 'package:e7gz_call_center/View/Notification/ShowAllNotification.dart';
import 'package:e7gz_call_center/View/ShowAppointment/ShowMyAppointments.dart';
import 'package:get/get.dart';

class Pages {

  static final routes =[

    GetPage(
      name: '/Login',
      page: () => Login(),
      binding: LoginBinding(),
    ),

     GetPage(
       name: '/Profile',
       page: () => Profile(),
       binding: ProfileBinding(),
    ),

    GetPage(
      name: '/AllDoctors',
      page: () => AllDoctors(),
      binding: AllDoctorsBinding(),
    ),


    GetPage(
      name: '/ShowMyAppointments',
      page: () => ShowMyAppointments(),
      binding: ShowMyAppointmentsBinding(),
    ),

    GetPage(
      name: '/Chats',
      page: () => Chat(),
      binding: ChatsBinding(),
    ),
  ];
}