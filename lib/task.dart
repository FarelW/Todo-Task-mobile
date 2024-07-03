class Task {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime created;
  final DateTime? duedate;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.isDone,
    required this.created,
    this.duedate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'],
      created: DateTime.parse(json['created']),
      duedate: json['duedate'] != null ? DateTime.parse(json['duedate']) : null,
    );
  }
}
