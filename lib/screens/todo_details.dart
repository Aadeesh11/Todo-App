import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/widgets/edit_delete_buttons.dart';

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
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  var flag = false;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Description: ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              todo.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Complete it before: ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat.yMEd().format(todo.completebefore),
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Text(
              todo.completebefore.hour.toString().padLeft(2, '0') +
                  ':' +
                  todo.completebefore.minute.toString().padRight(2, '0'),
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
