class User {
  int idUsuario = 0;
  String login = '';
  String contrasena = '';
  String? nombre = '';
  String? apellido = '';
  int? estado = 0;
  int? habilitaAPP = 0;
  int? habilitaFotos = 0;
  String habilitaFlotas = '';
  String modulo = '';
  String codigoCausante = '';
  bool? estadoInv = false;
  bool? compras = true;
  String? codigogrupo = '';

  User({
    required this.idUsuario,
    required this.login,
    required this.contrasena,
    required this.nombre,
    required this.apellido,
    required this.estado,
    required this.habilitaAPP,
    required this.habilitaFotos,
    required this.habilitaFlotas,
    required this.modulo,
    required this.codigoCausante,
    required this.estadoInv,
    required this.compras,
    required this.codigogrupo,
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
    habilitaFlotas = json['habilitaFlotas'] ?? '';
    modulo = json['modulo'];
    codigoCausante = json['codigoCausante'];
    estadoInv = json['estadoInv'] ?? false;
    compras = json['compras'] ?? false;
    codigogrupo = json['codigogrupo'];
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
    data['habilitaFlotas'] = habilitaFlotas;
    data['modulo'] = modulo;
    data['codigoCausante'] = codigoCausante;
    data['estadoInv'] = estadoInv;
    data['compras'] = compras;
    data['codigogrupo'] = codigogrupo;

    return data;
  }
}
