import 'package:flutter/material.dart';
import 'package:todo_app/http/auth_helper.dart';
import 'package:todo_app/http/todo_crud_helper.dart';
import 'package:todo_app/models/todo_item_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _items = [];

  List<Todo> get items {
    return [..._items];
  }

  void logoutreset() {
    _items = [];
    notifyListeners();
  }

  Future<bool?> addTodo(String title, String? id, [bool update = false]) async {
    try {
      if (!update) {
        print("hora");
        final flag = await TodoCrud.addTodo('${AuthHelper.token()}', title);
        if (flag!) {
          final allTodo = await TodoCrud.getTodos('${AuthHelper.token()}');
          final newTodo = allTodo!.last;
          final newTo = Todo(
            id: newTodo['id'].toString(),
            title: newTodo['title'],
          );
          _items.add(newTo);
          notifyListeners();
          return true;
        }
      } else {
        print("hora");
        //Make an TodoCrud.update func
        final flag = await TodoCrud.editTodo(id!, title);
        if (flag!) {
          final i = _items.indexWhere((e) => e.id == id);
          _items[i].title = title;
          notifyListeners();
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool?> setTodo(String token) async {
    //from where called agar token
    final allTodo = await TodoCrud.getTodos(token);
    if (allTodo!.length != 0) {
      _items = allTodo.map(
        (e) {
          return Todo(
            title: e['title'],
            id: e['id'].toString(),
          );
        },
      ).toList();
      // print('wasmeok');
      notifyListeners();
      return true;
    } else if (allTodo.length == 0) {
      print('wasme');
      return true;
    } else {
      print('WASME');
      return false;
    }
  }

  Future<bool> removeTodo(String id) async {
    try {
      final flag = await TodoCrud.deleteTodo(id);
      if (flag == false) {
        return false;
      }
      _items.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
