import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class ApiHelper {
  static Future<Response> put(
      String controller, String id, Map<String, dynamic> request) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString('connection') ?? '';

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
      String controller, Map<String, dynamic> request) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString('connection') ?? '';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString('connection') ?? '';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString('connection') ?? '';
    var url = Uri.parse('$apiUrl/api/Account/GetObras/$proyectomodulo');
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString('connection') ?? '';
    var url = Uri.parse('$apiUrl/api/Account/GetObra/$id');
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
}
