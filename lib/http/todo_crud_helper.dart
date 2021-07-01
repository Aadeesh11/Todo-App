import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/http/auth_helper.dart';

String uri = "https://todo-app-csoc.herokuapp.com/";

Uri getUri(String endpoint) {
  return Uri.parse(uri + '$endpoint');
}

class TodoCrud {
  static Future<List<dynamic>?> getTodos(String token) async {
    final url = getUri("todo/");
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Token $token",
        },
      );
      if (response.statusCode == 200) {
        print(response.body.toString() + 'wasme');
        return jsonDecode(response.body);
      }
    } catch (err) {
      print(err.toString() + 'no');

      throw Exception('Please check your internet connection');
    }
  }

  static Future<bool?> addTodo(String token, String title) async {
    final url = getUri("todo/create/");
    print('hora1');
    try {
      http.Response response = await http.post(
        url,
        headers: {
          "Authorization": "Token $token",
        },
        body: {
          "title": title,
        },
      );
      print('hora2');
      if (response.statusCode == 200) {
        return true;
      }
    } catch (err) {
      throw Exception('Please check your internet connection');
    }
  }

  static Future<bool?> deleteTodo(String id) async {
    final url = getUri("todo/$id/");
    print('hora1');
    try {
      http.Response response = await http.delete(
        url,
        headers: {
          "Authorization": "Token ${AuthHelper.token()}",
        },
      );
      print('hora2');
      if (response.statusCode == 204) {
        return true;
      }
    } catch (err) {
      throw Exception('Please check your internet connection');
    }
  }
}
