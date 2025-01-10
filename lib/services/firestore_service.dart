import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 10;

  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  // Add a new task
  Future<void> addTask(String taskName) async {
    try {
      await _firestore.collection('tasks').add({
        'name': taskName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("Task added successfully: $taskName");
    } catch (e) {
      print("Failed to add task: $e");
      throw e;
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      print("Task deleted successfully: $taskId");
    } catch (e) {
      print("Failed to delete task: $e");
      throw e;
    }
  }

  // Batch write: Add multiple tasks
  Future<void> addTasksInBatch() async {
    try {
      WriteBatch batch = _firestore.batch();
      for (int i = 0; i < 5; i++) {
        DocumentReference taskRef = _firestore.collection('tasks').doc();
        batch.set(taskRef, {
          'name': 'Task ${DateTime.now().millisecondsSinceEpoch + i}',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      print("Batch tasks added successfully");
    } catch (e) {
      print("Failed to add batch tasks: $e");
      throw e;
    }
  }

  // Update a task using transaction
  Future<void> updateTask(String taskId, String newName) async {
    try {
      DocumentReference taskRef = _firestore.collection('tasks').doc(taskId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(taskRef);
        if (snapshot.exists) {
          transaction.update(taskRef, {'name': newName});
        } else {
          throw Exception('Task does not exist!');
        }
      });
      print("Task updated successfully: $taskId");
    } catch (e) {
      print("Failed to update task: $e");
      throw e;
    }
  }

  // Fetch tasks with pagination
  Future<List<DocumentSnapshot>> fetchTasks(
      {bool isInitialFetch = false}) async {
    if (!_hasMoreData && !isInitialFetch) return [];

    try {
      Query query = _firestore
          .collection('tasks')
          .orderBy('createdAt', descending: true)
          .limit(_pageSize);

      if (isInitialFetch) {
        _lastDocument = null;
        _hasMoreData = true;
      } else if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.length < _pageSize) {
        _hasMoreData = false;
      }

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      }

      return querySnapshot.docs;
    } catch (e) {
      print("Failed to fetch tasks: $e");
      throw e;
    }
  }

  // Stream for real-time updates
  Stream<QuerySnapshot> getTaskStream() {
    return _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  bool get hasMoreData => _hasMoreData;
}
