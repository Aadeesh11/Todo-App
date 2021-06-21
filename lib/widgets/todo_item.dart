import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/screens/todo_details.dart';
import 'package:todo_app/widgets/edit_delete_buttons.dart';

class TodoItem extends StatelessWidget {
  final List<Todo> todos;
  final int i;
  const TodoItem({Key? key, required this.todos, required this.i})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: true,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => TodoDetails(
            todo: todos[i],
          ),
        ),
      ),
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
              todos[i].completebefore,
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            todos[i].completebefore.hour.toString().padLeft(2, '0') +
                ':' +
                todos[i].completebefore.minute.toString().padRight(2, '0'),
          ),
        ],
      ),
      trailing: ActionButtons(
        todo: todos[i],
      ),
    );
  }
}
