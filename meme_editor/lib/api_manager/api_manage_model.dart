import 'api_base_helper.dart';

class APIManagerModel {
  String url;
  APIMethod method;
  dynamic body;
  Map<String, String>? header;
  bool isTokenRequired = true;

  APIManagerModel(
      {required this.url, required this.method, this.body,  this.header, required this.isTokenRequired});
}
