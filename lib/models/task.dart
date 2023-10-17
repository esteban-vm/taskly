final class Task {
  String content;
  DateTime timestamp;
  bool done;

  Task({required this.content, required this.timestamp, this.done = false});

  factory Task.fromMap(Map task) {
    return Task(
        content: task["content"],
        timestamp: task["timestamp"],
        done: task["done"]);
  }

  Map toMap() => {"content": content, "timestamp": timestamp, "done": done};
}
