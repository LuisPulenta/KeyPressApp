class PEPedido {
  int nroPedido = 0;
  String fecha = '';
  String estado = '';
  String nroPedidoObra = '';
  int totalItemAprobados = 0;
  double importeAprobados = 0.0;
  int idusuario = 0;
  int idfirma = 0;

  PEPedido({
    required this.nroPedido,
    required this.fecha,
    required this.estado,
    required this.nroPedidoObra,
    required this.totalItemAprobados,
    required this.importeAprobados,
    required this.idusuario,
    required this.idfirma,
  });

  PEPedido.fromJson(Map<String, dynamic> json) {
    nroPedido = json['nroPedido'];
    fecha = json['fecha'] ?? '';
    estado = json['estado'] ?? '';
    nroPedidoObra = json['nroPedidoObra'] ?? '';
    totalItemAprobados = json['totalItemAprobados'] ?? '';
    importeAprobados = json['importeAprobados'];
    idusuario = json['idusuario'];
    idfirma = json['idfirma'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroPedido'] = nroPedido;
    data['fecha'] = fecha;
    data['estado'] = estado;
    data['nroPedidoObra'] = nroPedidoObra;
    data['totalItemAprobados'] = totalItemAprobados;
    data['importeAprobados'] = importeAprobados;
    data['idusuario'] = idusuario;
    data['idfirma'] = idfirma;

    return data;
  }
}
