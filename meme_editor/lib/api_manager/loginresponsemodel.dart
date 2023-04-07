import 'package:meme_editor/api_manager/baseapiresponse.dart';

class LoginResponse extends BaseAPIResponse {
  ErrorLogin? errors;
  String? accessToken;
  String? refreshToken;
  int? expiresIn;
  int? statusCode;
  String? errorDescription;
  LoginResponse({this.errors});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details = json['details'];
    title = json['title'];
    errors = json['errors'];
    statusCode = json['statusCode'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    errorDescription = json['error_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['details'] = this.details;
    return data;
  }
}

class ErrorLogin {
  List<String>? mobileNumber;

  ErrorLogin({this.mobileNumber});

  ErrorLogin.fromJson(Map<String, dynamic> json) {
    if (json['MobileNumber'] != null) {
      mobileNumber =  [];
      json['MobileNumber'].forEach((v) {
        mobileNumber!.add(v);
      });
    }
  }
}