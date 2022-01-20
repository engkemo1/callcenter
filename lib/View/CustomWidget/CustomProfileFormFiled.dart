
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';

class CustomProfileFormFiled extends StatelessWidget {
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
  Function onChange;

  CustomProfileFormFiled({
    this.onSave,
    this.hint,
    this.enabled,
    this.myController,
    this.icon,
    this.onValidate,
    this.data,
    this.keybord,
    this.minLin,
    this.obscureText,
    this.onChange
  });

  String _errorMsg(String str) {
    switch (str) {
      case 'Enter your Title':
        return 'Title is empty !';
      case 'Enter your Email':
        return 'Email is empty !';
      case 'Enter your Password':
        return 'Password is empty !';
        default:
          return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled == null ? true : enabled,
      controller: myController,
      validator: onValidate,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: ConstStyles.BlackBackGround,fontWeight: FontWeight.bold,fontSize: 20),
      ),
      initialValue: data,
      obscureText: obscureText == null ?false:obscureText,
      onSaved: onSave,
      onChanged: onChange,
      style: TextStyle( color: ConstStyles.BlackBackGround,fontWeight: FontWeight.bold,fontSize: 20),
      keyboardType: keybord == null ? TextInputType.text : keybord,
      maxLines: minLin == null ? 1:minLin,
    );
  }

}
