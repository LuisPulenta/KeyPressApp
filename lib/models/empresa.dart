class Empresa {
  int id = 0;
  String nombreEmpresa = '';
  int habilitaEmpresa = 0;
  int habilitaObras = 0;
  int habilitaInventarios = 0;
  int habilitaInstalaciones = 0;
  int habilitaFlotas = 0;
  int habilitaRRHH = 0;
  int habilitaReciboSueldos = 0;
  String linkApi = '';
  int habilitaCompras = 0;

  Empresa(
      {required this.id,
      required this.nombreEmpresa,
      required this.habilitaEmpresa,
      required this.habilitaObras,
      required this.habilitaInventarios,
      required this.habilitaInstalaciones,
      required this.habilitaFlotas,
      required this.habilitaRRHH,
      required this.habilitaReciboSueldos,
      required this.linkApi,
      required this.habilitaCompras});

  Empresa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombreEmpresa = json['nombreEmpresa'];
    habilitaEmpresa = json['habilitaEmpresa'];
    habilitaObras = json['habilitaObras'];
    habilitaInventarios = json['habilitaInventarios'];
    habilitaInstalaciones = json['habilitaInstalaciones'];
    habilitaFlotas = json['habilitaFlotas'];
    habilitaRRHH = json['habilitaRRHH'];
    habilitaReciboSueldos = json['habilitaReciboSueldos'];
    linkApi = json['linkApi'];
    habilitaCompras = json['habilitaCompras'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombreEmpresa'] = nombreEmpresa;
    data['habilitaEmpresa'] = habilitaEmpresa;
    data['habilitaObras'] = habilitaObras;
    data['habilitaInventarios'] = habilitaInventarios;
    data['habilitaInstalaciones'] = habilitaInstalaciones;
    data['habilitaFlotas'] = habilitaFlotas;
    data['habilitaRRHH'] = habilitaRRHH;
    data['habilitaReciboSueldos'] = habilitaReciboSueldos;
    data['linkApi'] = linkApi;
    data['habilitaCompras'] = habilitaCompras;
    return data;
  }
}
