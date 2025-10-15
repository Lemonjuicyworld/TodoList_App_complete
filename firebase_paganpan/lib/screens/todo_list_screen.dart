import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../widgets/todo_item.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addTask(String task) async {
    if (task.isEmpty) return;
    await FirebaseFirestore.instance.collection('todos').add({
      'task': task,
      'createdAt': Timestamp.now(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TO-DO LIST')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTask(_controller.text),
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('todos')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('no task yet!'));
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final taskData = tasks[index].data() as Map<String, dynamic>?;

                    
                    final task = taskData?['task'] ?? 'Untitled task';
                    final createdAt = (taskData?['createdAt'] as Timestamp?)?.toDate();
                    final formattedDate = createdAt != null
                        ? DateFormat('MMM d, yyyy – hh:mm a').format(createdAt)
                        : 'Unknown date';

                    return TodoItem(
                      task: task,
                      date: formattedDate,
                      onDelete: () async {
                        await FirebaseFirestore.instance
                            .collection('todos')
                            .doc(tasks[index].id)
                            .delete();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
