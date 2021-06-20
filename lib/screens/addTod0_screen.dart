import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todoProvider.dart';

class AddTodo extends StatefulWidget {
  final String? title;
  final String? id;
  final String? date;
  AddTodo({Key? key, this.date, this.id, this.title}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    final _title = TextEditingController(text: widget.title ?? null);
    final _date = TextEditingController(text: widget.date ?? null);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title == null ? 'Add a new TO-DO' : 'Edit your Todo'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _title,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  DateTimePicker(
                    decoration:
                        InputDecoration(labelText: 'Complete task before'),
                    controller: _date,
                    type: DateTimePickerType.dateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ),
                ],
              ),
            ),
          ),

          RaisedButton.icon(
            onPressed: () {
              if (_title.text.isEmpty || _date.text.isEmpty) {
                return;
              } else {
                Provider.of<TodoProvider>(context, listen: false).addTodo(
                    _title.text,
                    DateTime.parse(_date.text),
                    widget.id ?? DateTime.now().toIso8601String(),
                    widget.id == null ? false : true);
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.check),
            label: widget.title == null ? Text('Save') : Text('Update'),
            elevation: 2,
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
          //RaisedButton.icon(onPressed: () {}, icon: icon, label: label)
        ],
      ),
    );
  }
}
