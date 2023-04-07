
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthManager {
  AuthManager._();

  static void logout(GlobalKey<ScaffoldState> _scaffoldKey) async {
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLggedIn', false);
    prefs.setDouble('expires_in', 0.0);
    prefs.setString('accessToken', '');
    prefs.setString('refreshToken', '');
    // if (AppGlobal.isMovedToLogin == false) {
    //   AppGlobal.isMovedToLogin = true;
    //   Navigator.pushAndRemoveUntil(
    //     _scaffoldKey.currentContext,
    //     MaterialPageRoute(builder: (context) => LoginScreen()),
    //     (Route<dynamic> route) => false,
    //   );
    // }
  
  }
}
