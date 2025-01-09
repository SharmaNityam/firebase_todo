import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class TaskList extends StatefulWidget {
  final FirestoreService firestoreService;

  const TaskList({
    super.key,
    required this.firestoreService,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<DocumentSnapshot> _tasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks(isInitialFetch: true);
  }

  Future<void> _fetchTasks({bool isInitialFetch = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    List<DocumentSnapshot> fetchedTasks = await widget.firestoreService
        .fetchTasks(isInitialFetch: isInitialFetch);
    setState(() {
      _tasks.addAll(fetchedTasks);
    });

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.firestoreService.getTaskStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Tasks Found'));
        }

        return ListView.builder(
          itemCount: _tasks.length + 1,
          itemBuilder: (context, index) {
            if (index == _tasks.length) {
              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: () => _fetchTasks(),
                      child: const Text('Load More'),
                    );
            }

            final doc = _tasks[index];
            return ListTile(
              title: Text(doc['name']),
              subtitle: Text(doc.id),
            );
          },
        );
      },
    );
  }
}
