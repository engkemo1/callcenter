import 'package:flutter/material.dart';

class LogoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // showSnackBar(SnackBar(content: CustomHeadersTextWhite(Txt: ConstString.NoAppointment)));
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo.png"),
            fit: BoxFit.contain,
          ),
        ),
        );
  }
}



