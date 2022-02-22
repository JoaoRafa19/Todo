import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/task.model.dart';

class TaskRepository {
  static String  taskColections = "tasks";
  final api = FirebaseFirestore.instance.collection(taskColections);

  TaskRepository();

  

  Future<DocumentReference> add(Task task) async {
    return await api.add(task.toJson());
  }
}
