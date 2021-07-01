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
                  Colors.tealAccent,
                  Colors.indigo,
                  Colors.deepOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.6, 0.9],
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
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
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
                          color: Colors.white,
                          //fontWeight: FontWeight.,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    // flex: deviceSize.width > 600 ? 2 : 1,
                    flex: 3,
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
  var key;
  @override
  void initState() {
    key = [UniqueKey(), UniqueKey(), UniqueKey(), UniqueKey(), UniqueKey()];
    super.initState();
  }

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
       
        if (token == 'Invalid') {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              return _showDialog('Invalid Credentials');
            },
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => TodoPage(),
            ),
          );
        }
      } else {
        final token = await AuthHelper.signUp(
            email: _authData['email']!,
            password: _authData['password']!,
            username: _authData['username']!,
            name: _authData['name']!);
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
            barrierDismissible: false,
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
              builder: (ctx) => TodoPage(),
            ),
          );
        }
      }
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return _showDialog('Network error');
        },
      );
    }
  }

  var signUp = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: () {
        signUp = !signUp;
      },
      height: mode == Mode.Signup ? 800 : 300,
      duration: Duration(milliseconds: signUp ? 500 : 1000),
      curve: signUp ? Curves.bounceOut : Curves.easeIn,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8.1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (mode == Mode.Signup)
                    TextFormField(
                      key: key[0],
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
                      key: key[1],
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
                    key: key[2],
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
                    key: key[3],
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
                      key: key[4],
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
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                    ),
                  FlatButton(
                    child: Text(
                        '${mode == Mode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
