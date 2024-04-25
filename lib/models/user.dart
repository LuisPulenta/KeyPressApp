class User {
  int idUsuario = 0;
  String login = '';
  String contrasena = '';
  String? nombre = '';
  String? apellido = '';
  int? estado = 0;
  int? habilitaAPP = 0;

  User({
    required this.idUsuario,
    required this.login,
    required this.contrasena,
    required this.nombre,
    required this.apellido,
    required this.estado,
    required this.habilitaAPP,
  });

  User.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    login = json['login'];
    contrasena = json['contrasena'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    estado = json['estado'];
    habilitaAPP = json['habilitaAPP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUsuario'] = idUsuario;
    data['login'] = login;
    data['contrasena'] = contrasena;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['estado'] = estado;
    data['habilitaAPP'] = habilitaAPP;

    return data;
  }
}
