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
  String codigoCausante = '';
  bool? estadoInv = false;
  bool? compras = true;

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
    required this.codigoCausante,
    required this.estadoInv,
    required this.compras,
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
    codigoCausante = json['codigoCausante'];
    estadoInv = json['estadoInv'] ?? false;
    compras = json['compras'] ?? false;
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
    data['codigoCausante'] = codigoCausante;
    data['estadoInv'] = estadoInv;
    data['compras'] = compras;

    return data;
  }
}
