class User {
  int idUsuario = 0;
  String login = '';
  String contrasena = '';
  String? nombre = '';
  String? apellido = '';
  int? estado = 0;
  int? habilitaAPP = 0;
  int? habilitaFotos = 0;
  String modulo = '';

  User({
    required this.idUsuario,
    required this.login,
    required this.contrasena,
    required this.nombre,
    required this.apellido,
    required this.estado,
    required this.habilitaAPP,
    required this.habilitaFotos,
    required this.modulo,
  });

  User.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    login = json['login'];
    contrasena = json['contrasena'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    estado = json['estado'];
    habilitaAPP = json['habilitaAPP'];
    habilitaFotos = json['habilitaFotos'];
    modulo = json['modulo'];
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
    data['habilitaFotos'] = habilitaFotos;
    data['modulo'] = modulo;
    return data;
  }
}
