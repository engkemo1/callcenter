import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomHeadersTextWhite extends StatelessWidget {
  final String Txt;
  final IconData imageIcon;

  CustomHeadersTextWhite({@required this.Txt , this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return Text(
      Txt,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: ConstStyles.BaseBackGround,
        fontWeight: FontWeight.bold,
        fontSize: 24,

      ),
    );
  }
}
