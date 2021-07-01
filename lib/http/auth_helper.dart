import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/providers/todoProvider.dart';

String uri = "https://todo-app-csoc.herokuapp.com/";

Uri getUri(String endpoint) {
  return Uri.parse(uri + '$endpoint');
}

String? _token;

Map<String, String> _user = {
  "name": '',
  "username": '',
  "email": '',
};

class AuthHelper {
  static String? token() {
    return _token;
  }

  static void logout() {
    _token = null;
    _user = {
      "name": '',
      "username": '',
      "email": '',
    };
  }

  static Map<String, String>? user() {
    final u = _user;
    return u;
  }

  static Future<void> getProfile() async {
    try {
      Uri url = getUri('auth/profile/');
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Token $_token",
        },
      );
      print("MFS");
      print(response.body + 'MFS');

      _user["name"] = jsonDecode(response.body)["name"];
      _user["username"] = jsonDecode(response.body)["username"];
      _user["email"] = jsonDecode(response.body)["email"];
      return;
    } catch (e) {
      print(e.toString() + 'MFS');
      throw Exception('NetWork Error');
    }
  }

  static Future<String?> login(String username, String password) async {
    Uri url = getUri('auth/login/');

    final response = await http.post(
      url,
      body: {
        "username": username,
        "password": password,
      },
    );
    print(response.body + 'token');
    if (response.statusCode == 200) {
      _token = jsonDecode(response.body)["token"];
      await getProfile();
      return '$_token';
      //SetTodos from where called
    } else if (response.statusCode == 400) {
      return 'Invalid';
    } else {
      throw Exception('NetWork Error');
    }
    //
  }

  static Future<String?> signUp({
    required String email,
    required String username,
    required String password,
    required String name,
  }) async {
    Uri url = getUri('auth/register/');
    final response = await http.post(
      url,
      body: {
        "name": name,
        "email": email,
        "username": username,
        "password": password,
      },
    );
    Map<String, dynamic> map = jsonDecode(response.body);
    print(response.body + 'okme');
    if (map.containsKey("token")) {
      _token = jsonDecode(response.body)["token"];
      _user = {
        "name": name,
        "email": email,
        "username": username,
      };
      return '$_token';
    } else if (map.containsKey("email") || map.containsKey("username")) {
      if (map.containsKey("email")) {
        return '(!)' + map["email"][0];
      } else
        return '(!)' + map["username"][0];
    } else {
      throw Exception('NetWork Error');
    }
  }
}
