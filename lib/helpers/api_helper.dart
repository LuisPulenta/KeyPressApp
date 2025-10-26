import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:keypressapp/shared_preferences/preferences.dart';

import '../models/models.dart';
import 'constants.dart';

class ApiHelper {
  //---------------------------------------------------------------------------
  static Future<Response> put(
    String controller,
    String id,
    Map<String, dynamic> request,
  ) async {
    String apiUrl = Preferences.connection;

    var url = Uri.parse('$apiUrl$controller$id');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> post(
    String controller,
    Map<String, dynamic> request,
  ) async {
    String apiUrl = Preferences.connection;

    var url = Uri.parse('$apiUrl$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true, result: response.body);
  }

  //---------------------------------------------------------------------------
  static Future<Response> delete(String controller, String id) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getObras(String proyectomodulo) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Obras/GetObras/$proyectomodulo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Obra> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Obra.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getObra(String id) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Obras/GetObra/$id');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Obra.fromJson(decodedJson));
  }

  //--------------------------------------------------------------
  static Future<Response> getEmpresas() async {
    var url = Uri.parse('${Constants.apiAppParametros}/api/empresa');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Empresa> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Empresa.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getEmpresa(String nombre) async {
    var url = Uri.parse(
      '${Constants.apiAppParametros}/api/Empresa/GetEmpresa/$nombre',
    );
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Empresa.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> putWebSesion(int nroConexion) async {
    String apiUrl = Preferences.connection;

    var url = Uri.parse('$apiUrl/api/WebSesions/$nroConexion');

    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: decodedJson);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPEPedidos(int idUsuario) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/PEPedidos/GetPEPedidos/$idUsuario');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<PEPedido> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(PEPedido.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPEPedidosByNroPedido(int nroPedido) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse(
      '$apiUrl/api/PEPedidos/GetPEPedidosByNroPedido/$nroPedido',
    );
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<PEPedido> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(PEPedido.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> postNoToken(
    String controller,
    Map<String, dynamic> request,
  ) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl$controller');
    var response = await http
        .post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode(request),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getNroRegistroMax() async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/VehiculosKilometraje/GetNroRegistroMax');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);

    return Response(isSuccess: true, result: decodedJson);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getProgramasPrev(String codigo) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Vehiculos/GetProgramasPrev/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehiculosProgramaPrev> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosProgramaPrev.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getVehiculoByChapa(String chapa) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Vehiculos/GetVehiculoByChapa/$chapa');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Vehiculo.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> getKilometrajes(String codigo) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Vehiculos/GetKilometrajes/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehiculosKilometraje> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosKilometraje.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPreventivos(String codigo) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Vehiculos/GetPreventivos/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Preventivo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Preventivo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getUsuarioChapa(String codigo) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Vehiculos/GetUsuarioChapa/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: VFlota.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> getVehiculosCheckLists(String idUser) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse(
      '$apiUrl/api/VehiculosCheckLists/GetVehiculosCheckLists/$idUser',
    );

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehiculosCheckList> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosCheckList.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCheckListFotos(String id) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse(
      '$apiUrl/api/VehiculosCheckListsFotos/GetVehiculosCheckListsFoto/$id',
    );
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<CheckListFoto> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CheckListFoto.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> deleteVehiculosCheckListsFoto(String id) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse(
      '$apiUrl/api/VehiculosCheckListsFotos/DeleteVehiculosCheckListsFoto/$id',
    );

    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> deleteVehiculosCheckListsFotos(String id) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse(
      '$apiUrl/api/VehiculosCheckListsFotos/DeleteVehiculosCheckListsFotos/$id',
    );

    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getClientes2() async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Clientes/GetClientes');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Cliente> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Cliente.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCausante(String codigo) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Causantes/GetCausanteByCodigo2/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Causante.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCausantesTalleres() async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Causantes/GetTalleres');

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Causante> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Causante.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getTurnos(String id) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/Vehiculos/GetTurnos/$id');

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Turno> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Turno.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getNotificationUsers() async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/UsuarioTokens/GetUsuarios');

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<NotificationUser> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(NotificationUser.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getNotificationToken() async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/token');

    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    Map<String, dynamic> jsonMap = jsonDecode(body);
    String accessToken = jsonMap['access_token'];

    return Response(isSuccess: true, result: accessToken);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getTokensByUser(String user) async {
    String apiUrl = Preferences.connection;
    var url = Uri.parse('$apiUrl/api/UsuarioTokens/GetTokensByUser/$user');

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<UserToken> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(UserToken.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }
}
