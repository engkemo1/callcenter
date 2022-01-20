import 'package:auto_size_text/auto_size_text.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DaysNum extends StatelessWidget {
  final String Txt;
  final double Fsize;
  final Color TxtColor;

  DaysNum({@required this.Txt,this.Fsize ,this.TxtColor });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      Txt,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: TxtColor == null ? ConstStyles.TextBackGround : TxtColor,
        fontWeight: FontWeight.bold,
        // fontSize: Fsize == null ? 22 : Fsize,
      ),
    );
  }
}
