class AccessTokenFetchRequest {
  String? scope;
  String? grantType;
  String? refreshToken;
  String? grantTypeCap;
  String? clientId;
  String? clientSecret;

  AccessTokenFetchRequest(
      {this.scope,
      this.refreshToken,
      this.grantTypeCap,
      this.grantType,
      this.clientId,
      this.clientSecret});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scope'] = this.scope;
    data['grant_type'] = this.grantType;
    data['refresh_token'] = this.refreshToken;
    data['GrantType'] = this.grantTypeCap;
    data['client_id'] = this.clientId;
    data['client_secret'] = this.clientSecret;

    return data;
  }
}