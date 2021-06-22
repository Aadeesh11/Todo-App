class Todo {
  String? id;
  String title;
  String desc;
  DateTime completebefore;
  Todo({
    this.id,
    //this.completebefore,
    required this.title,
    required this.completebefore,
    required this.desc,
  });
}
