import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/screens/addTodo_screen.dart';
import 'package:todo_app/screens/auth_screen.dart';
import 'package:todo_app/screens/search_todo.dart';
import 'package:todo_app/widgets/todo_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TodoProvider(),
      child: MaterialApp(
        title: 'TodoApp',
        theme: ThemeData(
          accentColor: Colors.deepOrange,
          primarySwatch: Colors.indigo,
        ),
        home: AuthScreen(),
      ),
    );
  }
}

class TodoPage extends StatelessWidget {
  final String token;
  TodoPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SearchScreen(),
                  ),
                );
              },
              icon: Icon(Icons.search))
        ],
        title: Text("Your todo list"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<TodoProvider>(context, listen: false).setTodo("$token"),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return Consumer<TodoProvider>(
                child: const Center(
                  child: Text('No Todos added yet'),
                ),
                builder: (ctx, todos, child) => todos.items.length <= 0
                    ? child!
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(4, 5, 4, 60),
                        child: ListView.separated(
                          separatorBuilder: (ctx, i) => Divider(
                            thickness: 2,
                          ),
                          itemBuilder: (ctx, i) =>
                              TodoItem(todos: todos.items, i: i),
                          itemCount: todos.items.length,
                        ),
                      ),
              );
            } else {
              return const Center(
                child: Text(
                    'Please check your internet connection or restart the app',
                    textAlign: TextAlign.center),
              );
            }
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddTodo(),
            ),
          );
        },
      ),
    );
  }
}
