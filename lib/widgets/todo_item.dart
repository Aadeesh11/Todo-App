import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/widgets/edit_delete_buttons.dart';

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
      trailing: ActionButtons(
        todo: todos[i],
      ),
    );
  }
}
