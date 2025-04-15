class Todo {
  final int? id;
  final String title;
  final String content;
  final DateTime startTime;
  final DateTime endTime;
  final int? reminderMinutes;

  Todo({
    this.id,
    required this.title,
    required this.content,
    required this.startTime,
    required this.endTime,
    this.reminderMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'reminder_minutes': reminderMinutes,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      content: map['content'], // Handle null content
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      reminderMinutes: map['reminder_minutes'],
    );
  }
}