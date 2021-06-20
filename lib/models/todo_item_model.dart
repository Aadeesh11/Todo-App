class Todo {
  String? id;
  String title;
  DateTime completebefore;
  Todo({
    this.id,
    //this.completebefore,
    required this.title,
    required this.completebefore,
  });
}
