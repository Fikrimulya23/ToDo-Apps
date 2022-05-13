class ToDo {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;

  ToDo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
  });

  ToDo.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"],
        date = res["date"],
        time = res["time"],
        location = res["location"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
    };
  }
}
