class NotificationUser {
  int id = 0;
  String usuario = '';
  String nombre = '';

  NotificationUser({
    required this.id,
    required this.usuario,
    required this.nombre,
  });

  NotificationUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuario = json['usuario'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['usuario'] = usuario;
    data['nombre'] = nombre;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'usuario': usuario, 'nombre': nombre};
  }
}
