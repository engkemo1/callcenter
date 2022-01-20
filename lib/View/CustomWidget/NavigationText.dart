import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';

class NavigationText extends StatelessWidget {
  final String Txt;

  NavigationText({@required this.Txt });

  @override
  Widget build(BuildContext context) {
    return Text(
      Txt,
      style: TextStyle(
        color: ConstStyles.BlackBackGround,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}