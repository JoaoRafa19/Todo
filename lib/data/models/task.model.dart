class Task {
  final bool done;
  final String task;
  final DateTime createAt;
  final DateTime updateAt;
  final DateTime deadline;
  final String uid;

  Task(this.done, this.task, this.createAt, this.updateAt, this.deadline, this.uid);

  Map<String, dynamic> toMap() {
    return {
      'done': done,
      'task': task,
      'createAt': createAt,
      'updateAt': updateAt,
      'deadline': deadline,
      'uid': uid,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      map['done'],
      map['task'],
      map['createAt'],
      map['updateAt'],
      map['deadline'],
      map['uid'],
    );
  }
}
