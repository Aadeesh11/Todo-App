import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/http/auth_helper.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/screens/auth_screen.dart';

class AppDrawer extends StatelessWidget {
  final Map<String, String>? user;
  const AppDrawer({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = user!["name"]!.split(' ');
    String first = name[0], second = name[0].substring(1);
    if (name.length > 1) {
      first = name[0];
      second = name[1];
    }
    return Drawer(
      elevation: 10,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 200
                          : 50,
                  width: double.infinity,
                  child: Container(
                    child: Image.network(
                      'https://ui-avatars.com/api/?name=$first+$second',
                      fit: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? BoxFit.cover
                          : null,
                      loadingBuilder:
                          (_, __, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return __;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      "Name: " + '${user!["name"]}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      'Email: ${user!["email"]}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'UserName: ${user!["username"]}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton.icon(
                        onPressed: () {
                          AuthHelper.logout();
                          Provider.of<TodoProvider>(context, listen: false)
                              .logoutreset();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx) => AuthScreen()));
                        },
                        icon: Icon(Icons.logout),
                        label: Text(
                          "Logout",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
