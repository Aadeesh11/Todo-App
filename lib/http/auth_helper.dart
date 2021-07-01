import 'dart:convert';
import 'package:http/http.dart' as http;

String uri = "https://todo-app-csoc.herokuapp.com/";

Uri getUri(String endpoint) {
  return Uri.parse(uri + '$endpoint');
}

String? _token;

class AuthHelper {
  static String? token() {
    return _token;
  }

  // void _setToken(String token) {
  //   _token = token;
  // }

  static Future<String?> login(String username, String password) async {
    Uri url = getUri('auth/login/');
    //Wrap this whole block in try and then use catch error implement for both signup and login
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
      return '$_token';
    } else if (map.containsKey("email") || map.containsKey("username")) {
      print(map["username"][0] + "jota");
      if (map.containsKey("email")) {
        return '(!)' + map["email"][0];
      } else
        return '(!)' + map["username"][0];
    } else {
      throw Exception('NetWork Error');
    }
  }
}
