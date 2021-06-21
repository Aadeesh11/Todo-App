import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/screens/addTod0_screen.dart';

class TodoItem extends StatelessWidget {
  final List<Todo> todos;
  final int i;
  const TodoItem({Key? key, required this.todos, required this.i})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Center(
          child: Text('${i + 1}'),
        ),
      ),
      title: Text(todos[i].title.trimRight()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Text(
            DateFormat.yMEd().format(
              DateTime.parse(todos[i].completebefore.toIso8601String()),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Text(todos[i].completebefore.hour.toString().padLeft(2, '0') +
              ':' +
              todos[i].completebefore.minute.toString().padRight(2, '0')),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AddTodo(
                        title: todos[i].title,
                        id: todos[i].id,
                        date: todos[i].completebefore.toIso8601String(),
                      )));
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.amber),
                                ),
                                onPressed: () {
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .removeTodo(todos[i].id!);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Yes'),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.amber),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No"),
                              )
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
    );
  }
}
