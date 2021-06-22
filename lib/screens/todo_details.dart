import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/providers/todoProvider.dart';

import 'addTodo_screen.dart';

class TodoDetails extends StatelessWidget {
  final Todo todo;

  const TodoDetails({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var todos = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          todo.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => AddTodo(
                        title: todo.title,
                        id: todo.id,
                        date: todo.completebefore.toIso8601String(),
                        desc: todo.desc,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return Dialog(
                        insetPadding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Are you sure you want to remove/mark todo as complete?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.amber),
                                    ),
                                    onPressed: () {
                                      Provider.of<TodoProvider>(context,
                                              listen: false)
                                          .removeTodo(todo.id!);

                                      Navigator.of(context)..pop()..pop();
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.amber),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.amber[400],
              margin: EdgeInsets.fromLTRB(5, 10, 5, 1),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Description',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Colors.tealAccent[100],
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: 175, minWidth: double.infinity, minHeight: 150),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Text(
                    todo.desc,
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1,
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.amber[400],
              margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Complete it before',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
              color: Colors.blue[400],
              child: Container(
                alignment: Alignment.center,
                width: 200,
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  DateFormat.yMEd().format(todo.completebefore),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.black,
              child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Text(
                  todo.completebefore.hour.toString().padLeft(2, '0') +
                      ':' +
                      todo.completebefore.minute.toString().padRight(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    //fontWeight: FontWe,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
