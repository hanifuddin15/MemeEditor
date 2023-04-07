import 'package:shared_preferences/shared_preferences.dart';

// https://medium.com/flutterdevs/using-sharedpreferences-in-flutter-251755f07127#:~:text=SharedPreferences%20is%20used%20for%20storing,persistent%20store%20for%20simple%20data.
enum SharedPreferenceKey { isLggedIn, isBanglaEnable }

class SharedPreferenceManager {
  SharedPreferenceManager._();
  //Add Value

  static expiresInToSF(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('expires_in', value);
  }

  static accessTokenToSF(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', value);
  }

  static refreshTokenToSF(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('refreshToken', value);
  }

  static isLggedInToSF(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLggedIn', value);
  }

  static addStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static addIntToSF(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static addDoubleToSF(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static addBoolToSF(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  //GetValues
 

  static getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('accessToken');
    return stringValue;
  }

  static getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('refreshToken');
    return stringValue;
  }

  static getExpiresInTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? stringValue = prefs.getDouble('expires_in');
    return stringValue;
  }

  static getIsLggedInSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? stringValue = prefs.getBool('isLggedIn');
    return stringValue;
  }

  static getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  static getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool(key);
    return boolValue;
  }

  static getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(key);
    return intValue;
  }

  static getDoubleValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double? doubleValue = prefs.getDouble(key);
    return doubleValue;
  }

  //Remove Values
  static removeValues(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static removeConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLggedIn');
    prefs.remove('accessToken');
    prefs.remove('expires_in');
    prefs.remove('refreshToken');
  }
}
