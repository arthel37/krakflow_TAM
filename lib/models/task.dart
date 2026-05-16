import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: Icon(icon),
          onPressed: () {
            bool currentState = icon == Icons.check_circle;
            if (onChanged != null) {
              onChanged!(!currentState);
            }
          },
        ),
      ),
    );
  }
}

class Task {
  final int id;
  final String title;
  final String deadline;
  final bool done;
  final String priority;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "deadline": deadline,
      "priority": priority,
      "done": done,
    };
  }

  factory Task.fromMap(Map map) {
    return Task(
      id: map["id"],
      title: map["title"],
      deadline: map["deadline"],
      priority: map["priority"],
      done: map["done"],
    );
  }
}
