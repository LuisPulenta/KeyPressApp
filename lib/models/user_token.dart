class UserToken {
  int? id;
  String? usuario;
  String? token;
  String? createDate;
  String? lastLoginDate;

  UserToken({
    this.id,
    this.usuario,
    this.token,
    this.createDate,
    this.lastLoginDate,
  });

  UserToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuario = json['usuario'];
    token = json['token'];
    createDate = json['createDate'];
    lastLoginDate = json['lastLoginDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['usuario'] = usuario;
    data['token'] = token;
    data['createDate'] = createDate;
    data['lastLoginDate'] = lastLoginDate;
    return data;
  }
}
