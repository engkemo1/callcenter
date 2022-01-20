import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomHeadersText extends StatelessWidget {
  final String Txt;
  final IconData imageIcon;

  CustomHeadersText({@required this.Txt , this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return Text(
      Txt,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: ConstStyles.BlackBackGround,
        fontWeight: FontWeight.bold,
        fontSize: 24,

      ),
    );
  }
}
