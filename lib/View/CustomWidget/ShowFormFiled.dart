import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';

class ShowFormFiled extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onSave;
  final Function onValidate;
  final myController;
  String data;
  final TextInputType keybord;
  var minLin;
  bool obscureText;
  bool enabled;
  double fontSize;
  TextAlign textAlign;

  ShowFormFiled({
    @required this.onSave,
    this.hint,
    this.enabled,
    this.myController,
    this.icon,
    this.onValidate,
    this.data,
    this.keybord,
    this.minLin,
    this.obscureText,
    this.fontSize,
    this.textAlign
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled == null ? true : enabled,
      controller: myController,
      validator: onValidate,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstStyles.TextBackGround),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstStyles.TextBackGround),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ConstStyles.TextBackGround),
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: ConstStyles.TextBackGround,
        filled: true,
        labelText: hint,
        labelStyle: TextStyle(color: ConstStyles.BlackBackGround,fontWeight: FontWeight.bold,fontSize: 20),
      ),
      initialValue: data,
      obscureText: obscureText == null ?false:obscureText,
      onSaved: onSave,
      style: TextStyle( color: ConstStyles.BlackBackGround,fontWeight: FontWeight.bold,fontSize: fontSize == null ? 20 :fontSize),
      keyboardType: keybord == null ? TextInputType.text : keybord,
      maxLines: minLin == null ? 1:minLin,
      textAlign: textAlign == null ? TextAlign.center:textAlign,
    );
  }

}
