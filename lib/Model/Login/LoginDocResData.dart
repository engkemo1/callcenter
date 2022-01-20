class LoginDocResData {
  int key;
  String accessToken;
  String tokenType;
  int expiresIn;
  String roles;
  String type;
  String name;

  LoginDocResData(
      {this.key,
        this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.roles,
        this.type,
        this.name});

  LoginDocResData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    roles = json['roles'];
    type = json['type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['roles'] = this.roles;
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}