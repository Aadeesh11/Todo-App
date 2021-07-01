import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/screens/addTodo_screen.dart';

class ActionButtons extends StatefulWidget {
  final Todo todo;
  const ActionButtons({Key? key, required this.todo}) : super(key: key);

  @override
  _ActionButtonsState createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isLoading)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddTodo(
                    title: widget.todo.title,
                    id: widget.todo.id,
                  ),
                ),
              );
            },
          ),
        if (!isLoading)
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
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final flag = await Provider.of<TodoProvider>(
                                          context,
                                          listen: false)
                                      .removeTodo(widget.todo.id);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (flag == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('No interent connection'),
                                      ),
                                    );
                                  }
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
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
