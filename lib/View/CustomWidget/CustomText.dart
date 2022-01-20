import 'package:auto_size_text/auto_size_text.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomText extends StatelessWidget {
  final String Txt;
  final IconData imageIcon;
  TextAlign alignText;
  double size;
  Color color;

  CustomText({@required this.Txt , this.imageIcon,this.alignText,this.size,this.color});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      Txt,
      textAlign: alignText == null ? TextAlign.center : alignText,
      style: TextStyle(
        color:color == null ? ConstStyles.TextBackGround : color,
        fontWeight: FontWeight.bold,
        // fontSize:size ==null ?20:size,
      ),
      minFontSize: 12,
      stepGranularity: 1,
      maxLines: 10,
    );
  }
}
