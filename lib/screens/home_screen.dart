import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../widgets/task_input.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore To-Do App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _firestoreService.addTasksInBatch,
            tooltip: 'Add Tasks in Batch',
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Widget
          TaskInput(
            controller: _taskController,
            onAddTask: (taskName) {
              if (taskName.isNotEmpty) {
                _firestoreService.addTask(taskName);
                _taskController.clear();
              }
            },
          ),
          // Task List Widget
          Expanded(
            child: TaskList(
              firestoreService: _firestoreService,
            ),
          ),
        ],
      ),
    );
  }
}
