import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meme_editor/api_manager/AccessTokenFetchRequest.dart';
import 'package:meme_editor/api_manager/api_manage_model.dart';
import 'package:meme_editor/api_manager/app_auth_manager.dart';
import 'package:meme_editor/api_manager/app_exceptions.dart';
import 'package:meme_editor/api_manager/loginresponsemodel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

enum APIMethod { getMethod, postMethod, putMethod, deleteMethod }

class ApiBaseHelper {
  final String _baseUrl =
      "https://wazdi.org/api/v1/"; // "https://api.keyshild.com/api/v1/";
  final GlobalKey<ScaffoldState> uikey;
  ApiBaseHelper(this.uikey);

  String getBaseurl() {
    return _baseUrl;
  }

  Future<bool> _checkTokenAlive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentTimeInt = DateTime.now().millisecondsSinceEpoch;
    var wilExpiresIn = prefs.getInt('expiresIn');
    var loggedInTime = prefs.getInt('login_api_called');

    var remainingTime = currentTimeInt - loggedInTime!;
    var willExpireInMiliSec = wilExpiresIn! * 1000;
    print("RemainingTime: $remainingTime");
    print("WilExpiresIn: $willExpireInMiliSec");

    if (remainingTime < willExpireInMiliSec) {
      print(
          "☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️ AccessToken Alive ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️");
      return true;
    } else {
      print(
          "☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️ AccessToken Not Alive ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️");
      return false;
    }
  }

  Future<dynamic> manageAPI(
      {required APIManagerModel requestData, bool isForLogin = false}) async {
    if (isForLogin) {
      if (requestData.method == APIMethod.getMethod) {
        return await _get(requestData: requestData);
      } else {
        return await _post(requestData: requestData);
      }
    } else {
      return await _manageTokenAndAPI(requestData: requestData);
    }
  }

  Future<dynamic> _manageTokenAndAPI(
      {required APIManagerModel requestData}) async {
    var isTokenALive = await _checkTokenAlive();
    if (isTokenALive) {
      switch (requestData.method) {
        case APIMethod.getMethod:
          return await _get(requestData: requestData);
          break;
        case APIMethod.postMethod:
          return await _post(requestData: requestData);
          break;
        default:
          return throw FetchDataException(
              'Error occured while Communication with Server with StatusCode }');
      }
    } else {
      return await _fetchNewAccessToken(requestData: requestData);
    }
  }

  Future<dynamic> _get({required APIManagerModel requestData}) async {
    Map<String, String> header;

    if (requestData.header == null) {
      header = {
        'ContentType': 'application/x-www-form-urlencoded',
      };
    } else {
      header = requestData.header!;
    }

    if (requestData.isTokenRequired) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      header.addAll({'Authorization': 'Bearer $token'});
    }

    var combinedUrl = _baseUrl + requestData.url;
    print('Api Get, url $combinedUrl');
    var responseJson;
    try {
      final response = await http.get(Uri.parse(combinedUrl), headers: header);
      responseJson = _returnResponse(response, requestData: requestData);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> _post({
    required APIManagerModel requestData,
  }) async {
    var apiUrl = _baseUrl + requestData.url;

    Map<String, String> header;

    var data = requestData.body;

    print("API Url: $apiUrl, body: $data");

    if (requestData.header == null) {
      header = {
        'ContentType': 'application/x-www-form-urlencoded',
      };
    } else {
      header = requestData.header!;
    }

    if (requestData.isTokenRequired) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      header.addAll({'Authorization': 'Bearer $token'});
    }
    var responseJson;
    try {
      final response = await http.post(Uri.parse(apiUrl),
          body: requestData.body, headers: header);
      responseJson = _returnResponse(response, requestData: requestData);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> uploadmultipleimage(
      {required String severUrl,
      required File imageFile,
      required bool isTokenRequired}) async {
    var apiUrl = _baseUrl + severUrl;
    var uri = Uri.parse(apiUrl);
    print('Api Get, url $apiUrl');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    Map<String, String> header = {
      'content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('ProfileImage', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.headers.addAll(header);
    request.files.add(multipartFile);

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> customResponse = Map<String, dynamic>();
      customResponse['message'] = 'Profile image update successful';
      customResponse['status'] = 200;
      return customResponse;
    } else {
      Map<String, dynamic> customResponse = Map<String, dynamic>();
      customResponse['message'] = 'Profile image update failed';
      customResponse['status'] = 500;
      return customResponse;
    }

    // listen for response
  }

  Future<dynamic> _returnResponse(http.Response response,
      {required APIManagerModel requestData}) async {
    var code = response.statusCode;
    print("🦩🦩🦩API Response Code $code🦩🦩🦩");

    switch (response.statusCode) {
      case 2130:
      case 200:
        if (response.body.trim().isEmpty) {
          Map<String, dynamic> customResponse = Map<String, dynamic>();
          customResponse['message'] = 'success';
          customResponse['status'] = 200;
          return customResponse;
        } else {
          var responseJson = json.decode(response.body.toString());
          print(responseJson);
          return responseJson;
        }
        break;
      case 400:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 401:
        return await _fetchNewAccessToken(requestData: requestData);
        break;
      case 403:
        AuthManager.logout(uikey);
        return throw UnauthorisedException(response.body.toString());
      case 422:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        // AuthManager.logout();
        return responseJson;
      //throw BadRequestException(response.body.toString());
      case 451:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 500:
        return throw ServerErrorException(
            'Server error with StatusCode : ${response.statusCode}');
      default:
        return throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

//Fethch New AccessToken Token
  Future<dynamic> _fetchNewAccessToken(
      {required APIManagerModel requestData}) async {
    String _baseUrl = "https://wazdi.org/api/v1/";
    var url = 'connect/token';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refreshRoken = prefs.getString('refreshToken');
    if (refreshRoken == null) {
      AuthManager.logout(uikey);
      return;
    }
    AccessTokenFetchRequest data = AccessTokenFetchRequest(
        grantType: "refresh_token",
        scope: "offline_access",
        refreshToken: refreshRoken,
        grantTypeCap: "refresh_token",
        clientId: "ClientApp",
        clientSecret: "O1ZeoTA_RV");

    Map<String, String> header = {
      'ContentType': 'application/x-www-form-urlencoded',
    };

    print(
        "☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️ Fetching Access Token ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️");
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: data.toJson(), headers: header);
      switch (response.statusCode) {
        case 200:
          if (response.body.trim().isNotEmpty) {
            var responseJson = json.decode(response.body.toString());
            var responseData = LoginResponse.fromJson(responseJson);
            if (responseData.accessToken != null) {
              prefs.setString('accessToken', responseData.accessToken!);
            }
            if (responseData.refreshToken != null) {
              prefs.setString('refreshToken', responseData.refreshToken!);
            }
            if (responseData.expiresIn != null) {
              prefs.setInt('expiresIn', responseData.expiresIn!);
            }
            prefs.setInt(
                'login_api_called', DateTime.now().millisecondsSinceEpoch);
            return await manageAPI(requestData: requestData);
          } else {
            AuthManager.logout(uikey);
            return FetchDataException(
                'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
          }
          break;
        case 400:
        case 422:
          return throw BadRequestException(response.body.toString());
        case 401:
        case 403:
          return UnauthorisedException(response.body.toString());
        case 500:
          return ServerErrorException(
              'Server error with StatusCode : ${response.statusCode}');
        default:
          return FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      }
    } on SocketException {
      AuthManager.logout(uikey);
      print('No net');
      return throw FetchDataException('No Internet connection');
    }
  }
}
