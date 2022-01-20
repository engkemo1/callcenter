import 'package:e7gz_call_center/Pages.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'as DotEnv;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  await DotEnv.load(fileName:'.env');
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: ConstStyles.BaseBackGround));
  // runApp(DevicePreview(
  //     builder:(context) => MyApp()));
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: ConstString.AppName,
      defaultTransition: Transition.fade,
      locale: Locale('ar', 'EG'),
      theme: ThemeData(
        backgroundColor: ConstStyles.BaseBackGround,
        appBarTheme: AppBarTheme(
          backgroundColor: ConstStyles.ViewsBackGround,
          centerTitle: true,
        ),
        primarySwatch: Colors.blue,
      ),
      // home: MessagesScreen(),
      initialRoute: getStorage.read(ConstString.MyTokenKey) != null ? 'AllDoctors' : '/Login',
      getPages: Pages.routes,
    );
  }

}

