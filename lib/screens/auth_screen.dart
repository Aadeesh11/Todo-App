import 'package:flutter/material.dart';
import 'package:todo_app/http/auth_helper.dart';

import '../main.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum Mode { Login, Signup }

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'TO-DO',
                        style: TextStyle(
                          // color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 45,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Auth(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  Mode mode = Mode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': '',
    'name': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _switchAuthMode() {
    if (mode == Mode.Login) {
      setState(() {
        mode = Mode.Signup;
      });
    } else {
      setState(() {
        mode = Mode.Login;
      });
    }
  }

  Widget _showDialog(String msg) {
    return Dialog(
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = false;
                });
              },
              child: Text('Try Again?'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authData['name'] == '' /*means we are loggin in */) {
        final token = await AuthHelper.login(
            _authData['username'] as String, _authData['password'] as String);
        print("$token token");
        if (token == 'Invalid') {
          showDialog(
            context: context,
            builder: (ctx) {
              return _showDialog('Invalid Credentials');
            },
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => TodoPage(token: token as String),
            ),
          );
        }
      } else {
        final token = await AuthHelper.signUp(
            email: _authData['email'] as String,
            password: _authData['password'] as String,
            username: _authData['username'] as String,
            name: _authData['name'] as String);
        if (token == null) {
          showDialog(
            context: context,
            builder: (ctx) {
              return _showDialog('Network error');
            },
          );
          return;
        } else if (token.contains('(!)')) {
          showDialog(
            context: context,
            builder: (ctx) {
              return _showDialog(
                token.substring(3),
              );
            },
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => TodoPage(token: token),
            ),
          );
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return _showDialog('Network error');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8.1,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        height: mode == Mode.Signup ? 500 : 300,
        constraints: BoxConstraints(
          minHeight: mode == Mode.Signup ? 500 : 300,
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (mode == Mode.Signup)
                  TextFormField(
                    maxLength: 150,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length == 0) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['name'] = val as String;
                    },
                  ),
                if (mode == Mode.Signup)
                  TextFormField(
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@') ||
                          value.trim().length == 0) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value as String;
                    },
                  ),
                TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length == 0) {
                      return 'username is too short';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['username'] = value as String;
                  },
                ),
                TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length == 0) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value as String;
                  },
                ),
                if (mode == Mode.Signup)
                  TextFormField(
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords dont match!';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(mode == Mode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                  ),
                FlatButton(
                  child: Text(
                      '${mode == Mode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
