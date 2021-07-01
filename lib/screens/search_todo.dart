import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/widgets/todo_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FloatingSearchBarController _query;
  List<Todo> items = [];

  @override
  void didChangeDependencies() {
    _query.query = '';
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _query = FloatingSearchBarController();
    super.initState();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var todos = Provider.of<TodoProvider>(context);
    return Scaffold(
      body: FloatingSearchAppBar(
          iconColor: Colors.amberAccent,
          colorOnScroll: Colors.indigo,
          liftOnScrollElevation: 10,
          alwaysOpened: true,
          color: Colors.indigo,
          titleStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          controller: _query,
          actions: [
            FloatingSearchBarAction.searchToClear(),
          ],
          elevation: 4,
          debounceDelay: Duration(milliseconds: 100),
          onQueryChanged: (query) {
            if (query.isEmpty) {
              setState(() {
                items = [];
              });
              return;
            }
            setState(
              () {
                items = todos.items.where(
                  (e) {
                    return e.title.toLowerCase().contains(
                          query.toLowerCase(),
                        );
                  },
                ).toList();
              },
            );
          },
          onSubmitted: (query) {
            if (query.isEmpty) {
              setState(() {
                items = [];
              });
              return;
            }
            setState(
              () {
                items = todos.items.where(
                  (e) {
                    return e.title.toLowerCase().contains(
                          query.toLowerCase(),
                        );
                  },
                ).toList();
              },
            );
          },
          hint: 'Search for a To-do',
          body: ListView.separated(
            itemBuilder: (_, i) => TodoItem(todos: items, i: i),
            separatorBuilder: (_, __) => Divider(),
            itemCount: items.length,
          )),
    );
  }
}
