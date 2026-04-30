// https://medium.com/@mohitarora7272/singleton-pattern-in-flutter-a-comprehensive-guide-a223e1be37b4
import 'dart:convert';

import 'package:ea_seminario_flutter/models/task.dart';
import 'package:ea_seminario_flutter/utils/constants.dart';
import 'package:http/http.dart' as http;

class TareaService {
  static const String _url = ('${AppConstants.baseUrl}/tareas');

  static TareaService? _instance;
  TareaService._();

  factory TareaService() {
    _instance ??= TareaService._();
    return _instance!;
  }
  void doSomething() {
    print('Hello world!');
  }

  Future<List<Task>> readTaskByUsuario(String id) async {
    var url = Uri.parse('${_url}/usuario/${id}');
    var res = await http.get(url);
    try {
      if (res.statusCode == 200) {
        List<dynamic> body = json.decode(res.body);
        return body.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Error al conectar con el backend: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception(
        'No se pudo conectar al backend. ¿Está corriendo en el puerto 1337? Error: $e',
      );
    }
  }
}
