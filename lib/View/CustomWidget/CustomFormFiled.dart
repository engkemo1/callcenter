
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
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

  CustomFormField({
    @required this.onSave,
    @required this.hint,
    this.enabled,
    this.myController,
    this.icon,
    this.onValidate,
    this.data,
    this.keybord,
    this.minLin,
    this.obscureText
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
      // decoration: InputDecoration(
      //   enabledBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: ConstStyles.BaseBackGround),
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: ConstStyles.BaseBackGround),
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   border: OutlineInputBorder(
      //     borderSide: BorderSide(color: ConstStyles.TextBackGround),
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   fillColor: ConstStyles.BaseBackGround,
      //   filled: true,
      //   prefixIcon: Icon(
      //     icon,
      //     color: ConstStyles.ViewsBackGround,
      //   ),
      //   labelText: hint,
      //   labelStyle: TextStyle(color: ConstStyles.TextBackGround,fontWeight: FontWeight.bold,fontSize: 20),
      // ),
      initialValue: data,
      obscureText: obscureText == null ?false:obscureText,
      onSaved: onSave,
      style: TextStyle( color: ConstStyles.BlackBackGround,fontWeight: FontWeight.bold,fontSize: 20),
      keyboardType: keybord == null ? TextInputType.text : keybord,
      maxLines: minLin == null ? 1:minLin,
    );
  }

}
