import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/screens/addTod0_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TodoProvider(),
      child: MaterialApp(
        title: 'TodoApp',
        theme: ThemeData(
          accentColor: Colors.deepOrange,
          primarySwatch: Colors.purple,
          primaryColor: Colors.blue,
        ),
        home: TodoPage(),
      ),
    );
  }
}

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your todo list"),
      ),
      body: FutureBuilder(
        future: Provider.of<TodoProvider>(context, listen: false).setTodo(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<TodoProvider>(
              child: Center(
                child: Text('No Todos added yet'),
              ),
              builder: (ctx, todos,
                      ch /*()child passed above is passed here as ch*/) =>
                  todos.items.length <= 0
                      ? ch!
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                            separatorBuilder: (ctx, i) => Divider(
                              thickness: 2,
                            ),
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Center(
                                  child: Text('${i + 1}'),
                                ),
                              ),
                              title: Text(todos.items[i].title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    DateFormat.yMEd().format(
                                      DateTime.parse(todos
                                          .items[i].completebefore
                                          .toIso8601String()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(todos.items[i].completebefore.hour
                                          .toString()
                                          .padLeft(2, '0') +
                                      ':' +
                                      todos.items[i].completebefore.minute
                                          .toString()
                                          .padRight(2, '0')),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => AddTodo(
                                                    title: todos.items[i].title,
                                                    id: todos.items[i].id,
                                                    date: todos
                                                        .items[i].completebefore
                                                        .toIso8601String(),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Are you sure you want to remove/mark todo as complete?",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .amber),
                                                            ),
                                                            onPressed: () {
                                                              todos.removeTodo(
                                                                  todos.items[i]
                                                                      .id!);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .amber),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text("No"),
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ],
                              ),
                              // title: Text(greatPlaces.items[i].title),
                              // subtitle:
                              //     Text(greatPlaces.items[i].location.address),
                              // onTap: () {
                              //   Navigator.of(context).pushNamed(
                              //       PlaceDetailScreen.routeName,
                              //       arguments: greatPlaces.items[i].id);
                              // },
                            ),
                            itemCount: todos.items.length,
                          ),
                        ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => AddTodo()));
        },
      ),
    );
  }
}
