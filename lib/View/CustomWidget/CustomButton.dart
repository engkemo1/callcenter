import 'package:auto_size_text/auto_size_text.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onClick;
  final double paddingSize;

  CustomButton({@required this.text, @required this.onClick,this.paddingSize});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: ConstStyles.ViewsBackGround,
      child: AutoSizeText(
        text.toUpperCase(),
        style: TextStyle(
            color: ConstStyles.BaseBackGround, fontWeight: FontWeight.bold,),
      ),
      onPressed: onClick,
    );
  }
}
