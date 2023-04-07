class BaseAPIResponse {
  int ?status;
  String? details;
  String? message;
  String ?title;

  BaseAPIResponse({this.status, this.message, this.details, this.title});
}