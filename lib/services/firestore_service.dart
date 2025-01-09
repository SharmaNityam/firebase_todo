import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 5;

  DocumentSnapshot? _lastDocument;

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
    }
  }

  // Batch write: Add multiple tasks
  Future<void> addTasksInBatch() async {
    WriteBatch batch = _firestore.batch();
    for (int i = 0; i < 5; i++) {
      DocumentReference taskRef = _firestore.collection('tasks').doc();
      batch.set(taskRef, {
        'name': 'Task ${DateTime.now().millisecondsSinceEpoch + i}',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  // Update a task using transaction
  Future<void> updateTask(String taskId, String newName) async {
    DocumentReference taskRef = _firestore.collection('tasks').doc(taskId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(taskRef);
      if (snapshot.exists) {
        transaction.update(taskRef, {'name': newName});
      }
    });
  }

  // Fetch tasks with pagination
  Future<List<DocumentSnapshot>> fetchTasks(
      {bool isInitialFetch = false}) async {
    Query query = _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .limit(_pageSize);
    if (!isInitialFetch && _lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
    }
    return querySnapshot.docs;
  }

  // Stream for real-time updates
  Stream<QuerySnapshot> getTaskStream() {
    return _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
