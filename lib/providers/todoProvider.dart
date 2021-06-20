import 'package:flutter/material.dart';
import 'package:todo_app/db/todo_db.dart';
import 'package:todo_app/models/todo_item_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _items = [];

  List<Todo> get items {
    return [..._items];
  }

  Future<void> addTodo(String title, DateTime date, String id,
      [bool update = false]) async {
    if (!update) {
      final newTodo = Todo(id: id, title: title, completebefore: date);
      _items.add(newTodo);
    } else {
      final i = _items.indexWhere((e) => e.id == id);
      _items[i].title = title;
      _items[i].completebefore = date;
    }
    notifyListeners();
    TodoDb.insert('todo', {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
    });
  }

  Future<void> setTodo() async {
    final allTodo = await TodoDb.getData('todo');
    _items = allTodo.map((e) {
      return Todo(
        title: e['title'],
        id: e['id'],
        completebefore: DateTime.parse(e['date']),
      );
    }).toList();
    notifyListeners();
  }

  Future<void> removeTodo(String id) async {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    TodoDb.remove(id);
  }
}
