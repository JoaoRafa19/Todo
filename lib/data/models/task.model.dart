import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Task {
  bool? done;
  String? task;
  DateTime? createAt;
  DateTime? updateAt;
  DateTime? deadline;
  String? uid;
  String? id;

  Task({
    this.done,
    this.task,
    this.createAt,
    this.updateAt,
    this.deadline,
    this.uid,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'done': done,
      'task': task,
      'createAt': createAt,
      'updateAt': updateAt,
      'deadline': deadline,
      'uid': uid,
      'id': id
    };
  }

  factory Task.newtask({String? task, DateTime? deadline, String? uid}) {
    return Task(
        task: task,
        uid: uid,
        done: false,
        createAt: DateTime.now(),
        updateAt: DateTime.now(),
        deadline: deadline,
        id: const Uuid().v4());
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      done: json['done'],
      task: json['task'],
      createAt: (json['createAt'] as Timestamp).toDate(),
      updateAt: (json['updateAt'] as Timestamp).toDate(),
      deadline: (json['deadline'] as Timestamp).toDate(),
      uid: json['uid'],
      id: json['id'],
    );
  }
}
