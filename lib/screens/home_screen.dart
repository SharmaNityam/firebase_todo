import 'package:flutter/material.dart';
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF4CAF50),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Firestore To-Do App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.add_task, color: Colors.white),
                onPressed: _firestoreService.addTasksInBatch,
                tooltip: 'Add Tasks in Batch',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            TaskInput(
              controller: _taskController,
              onAddTask: (taskName) {
                if (taskName.isNotEmpty) {
                  _firestoreService.addTask(taskName);
                  _taskController.clear();
                }
              },
            ),
            Expanded(
              child: TaskList(
                firestoreService: _firestoreService,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
