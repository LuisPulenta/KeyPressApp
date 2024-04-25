class Empresa {
  int idEmpresa = 0;
  String nombreempresa = '';
  String? direccion = '';
  String? telefono = '';
  String? carpetaImagenes = '';
  String? mensageSSHH = '';
  bool activo = false;
  String? logoEmpresa = '';
  String? logoFullPath = '';
  String? conexionServidor = '';
  String? nombreBDObra = '';
  String? usuarioBDObra = '';
  String? passwordBDObra = '';
  String? nombreBDInv = '';
  String? usuarioBDInv = '';
  String? passwordBDInv = '';

  Empresa(
      {required this.idEmpresa,
      required this.nombreempresa,
      required this.direccion,
      required this.telefono,
      required this.carpetaImagenes,
      required this.mensageSSHH,
      required this.activo,
      required this.logoEmpresa,
      required this.logoFullPath,
      required this.conexionServidor,
      required this.nombreBDObra,
      required this.usuarioBDObra,
      required this.passwordBDObra,
      required this.nombreBDInv,
      required this.usuarioBDInv,
      required this.passwordBDInv});

  Empresa.fromJson(Map<String, dynamic> json) {
    idEmpresa = json['idEmpresa'];
    nombreempresa = json['nombreempresa'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    carpetaImagenes = json['carpetaImagenes'];
    mensageSSHH = json['mensageSSHH'];
    activo = json['activo'];
    logoEmpresa = json['logoEmpresa'];
    logoFullPath = json['logoFullPath'];
    conexionServidor = json['conexionServidor'];
    nombreBDObra = json['nombreBDObra'];
    usuarioBDObra = json['usuarioBDObra'];
    passwordBDObra = json['passwordBDObra'];
    nombreBDInv = json['nombreBDInv'];
    usuarioBDInv = json['usuarioBDInv'];
    passwordBDInv = json['passwordBDInv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEmpresa'] = idEmpresa;
    data['nombreempresa'] = nombreempresa;
    data['direccion'] = direccion;
    data['telefono'] = telefono;
    data['carpetaImagenes'] = carpetaImagenes;
    data['mensageSSHH'] = mensageSSHH;
    data['activo'] = activo;
    data['logoEmpresa'] = logoEmpresa;
    data['logoFullPath'] = logoFullPath;
    data['conexionServidor'] = conexionServidor;
    data['nombreBDObra'] = nombreBDObra;
    data['usuarioBDObra'] = usuarioBDObra;
    data['passwordBDObra'] = passwordBDObra;
    data['nombreBDInv'] = nombreBDInv;
    data['usuarioBDInv'] = usuarioBDInv;
    data['passwordBDInv'] = passwordBDInv;

    return data;
  }
}
