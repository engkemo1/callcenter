import 'package:auto_size_text/auto_size_text.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';

class CustomSmallButton extends StatelessWidget {
  final String text;
  final Function onClick;
  final double radius;
  final double fontSize;
  final Color color;
  final Color txtColor;

  CustomSmallButton({@required this.text, @required this.onClick,this.radius,this.fontSize,this.color,this.txtColor});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ==null ?50 : radius),

      ),
      color: color==null?ConstStyles.ViewsBackGround:color,
      child: AutoSizeText(
        text.toUpperCase(),
        style: TextStyle(
            color:txtColor == null ? ConstStyles.BaseBackGround:txtColor, fontWeight: FontWeight.bold,
            // fontSize:fontSize ==null? 20 : fontSize,
        ),
        minFontSize: 10,
        maxFontSize: 16,
        stepGranularity: 1,
        maxLines: 2,
      ),
      onPressed: onClick,
    );
  }
}
