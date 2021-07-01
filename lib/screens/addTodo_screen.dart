import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todoProvider.dart';

class AddTodo extends StatefulWidget {
  bool isLoading = false;
  final String? title;
  final String? id;

  AddTodo({
    Key? key,
    this.id,
    this.title,
  }) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    final _title = TextEditingController(text: widget.title ?? null);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title == null ? 'Add a new TO-DO' : 'Edit your Todo'),
      ),
      body: !widget.isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: [
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(labelText: 'Title'),
                            maxLength: 15,
                            controller: _title,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton.icon(
                    onPressed: () async {
                      if (_title.text.isEmpty ||
                          _title.text.trimRight().length == 0) {
                        return;
                      } else {
                        print("hora");
                        setState(() {
                          widget.isLoading = true;
                        });
                        final flag = await Provider.of<TodoProvider>(context,
                                listen: false)
                            .addTodo(
                          _title.text,
                          widget.id ?? null,
                          widget.id == null ? false : true,
                        );
                        if (!flag!) {
                          setState(() {
                            widget.isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No network'),
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(Icons.check),
                    textColor: Colors.white,
                    label: widget.title == null ? Text('Save') : Text('Update'),
                    elevation: 2,
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
            )
          : Center(
              child: Container(
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Adding your Todo, Please wait',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
