import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/task.model.dart';

class TaskRepository {
  TaskRepository._();

  static final TaskRepository instance = TaskRepository._();

  static String taskColections = "tasks";
  final api = FirebaseFirestore.instance.collection(taskColections);

  Future<DocumentReference> add(Task task) async {
    try {
      return await api.add(task.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(Task task) async {
    try {
      final _task = await api.where("id", isEqualTo: task.id).get();
      if (_task.docs.isNotEmpty) {
        await api.doc(_task.docs.first.id).update(task.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(Task task) async {
    try {
      final _task = await api.where("id", isEqualTo: task.id).get();
      if (_task.docs.isNotEmpty) {
        await api.doc(_task.docs.first.id).delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Task>> getAll() async {
    final snapshot = await api.get();
    return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }

  Future<List<Task>> getByUser(String userId) async {
    final snapshot = await api.where("uid", isEqualTo: userId).get();
    return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }

  Future<Task> getById(String id) async {
    try {
      final snapshot = await api.doc(id).get();
      if (snapshot.data() == null) {
        return Task.fromJson(snapshot.data()!);
      } else {
        throw Exception("Task not found");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Task>> getByDate(String date) async {
    final snapshot = await api.where("deadline", isLessThanOrEqualTo: date).get();
    return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }
}
