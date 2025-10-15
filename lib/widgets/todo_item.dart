import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String task;
  final String date;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.task,
    required this.date,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(task, style: const TextStyle(fontSize: 18)),
        subtitle: Text(date, style: const TextStyle(color: Colors.grey)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}