import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Create a new task
  Future<String> createTask(TaskModel task) async {
    try {
      String taskId = _uuid.v4();
      TaskModel newTask = task.copyWith(
        id: taskId,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('tasks').doc(taskId).set(newTask.toJson());
      return taskId;
    } catch (e) {
      rethrow;
    }
  }

  // Get all tasks for a project
  Future<List<TaskModel>> getTasksByProject(String projectId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .where('projectId', isEqualTo: projectId)
          .get();
      
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

// Get tasks assigned to a user
  Future<List<TaskModel>> getTasksByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .where('assignedTo', arrayContains: userId)
          .get();
      
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get task by id
  Future<TaskModel> getTaskById(String taskId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('tasks').doc(taskId).get();
      return TaskModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update task
  Future<void> updateTask(TaskModel task) async {
    try {
      return await _firestore
          .collection('tasks')
          .doc(task.id)
          .update(task.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Update task status
  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      return await _firestore.collection('tasks').doc(taskId).update({
        'status': status.toString().split('.').last,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Assign user to task
  Future<void> assignUserToTask(String taskId, String userId) async {
    try {
      return await _firestore.collection('tasks').doc(taskId).update({
        'assignedTo': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Remove user from task
  Future<void> removeUserFromTask(String taskId, String userId) async {
    try {
      return await _firestore.collection('tasks').doc(taskId).update({
        'assignedTo': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update task completion percentage
  Future<void> updateTaskCompletion(String taskId, int completionPercentage) async {
    try {
      return await _firestore.collection('tasks').doc(taskId).update({
        'completionPercentage': completionPercentage,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      return await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get tasks statistics for a project
  Future<Map<String, int>> getTaskStatisticsByProject(String projectId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .where('projectId', isEqualTo: projectId)
          .get();
      
      Map<String, int> stats = {
        'total': snapshot.docs.length,
        'pending': 0,
        'inProgress': 0,
        'completed': 0,
        'cancelled': 0,
      };
      
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] as String;
        stats[status] = (stats[status] ?? 0) + 1;
      }
      
      return stats;
    } catch (e) {
      rethrow;
    }
  }

  // Stream of tasks for a project
  Stream<List<TaskModel>> tasksStreamByProject(String projectId) {
    return _firestore
        .collection('tasks')
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Stream of tasks assigned to a user
  Stream<List<TaskModel>> tasksStreamByUser(String userId) {
    return _firestore
        .collection('tasks')
        .where('assignedTo', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}