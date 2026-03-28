import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

List<Task> tasks = [
  Task(
    title: "Projekt Flutter",
    deadline: "Jutro",
    done: false,
    priority: "Wysoki",
  ),
  Task(
    title: "Ćwiczenia z matematyki",
    deadline: "Dzisiaj",
    done: false,
    priority: "Średni",
  ),
  Task(
    title: "Przeczytać o widgetach",
    deadline: "W tym tygodniu",
    done: false,
    priority: "Niski",
  ),
  Task(
    title: "Poodkurzać",
    deadline: "W tym roku",
    done: false,
    priority: "Niski",
  ),
  Task(
    title: "Iść na zakupy",
    deadline: "Dzisiaj",
    done: false,
    priority: "Wysoki",
  ),
  Task(
    title: "Ponudzić się trochę",
    deadline: "Kiedykolwiek",
    done: false,
    priority: "Średni",
  ),
  Task(
    title: "Wyjść na piwo",
    deadline: "Wczoraj",
    done: true,
    priority: "Wysoki",
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrakFlow',
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("KrakFlow"),
                SizedBox(height: 20),
                Text("Organizacja studiów"),
                SizedBox(height: 20),
                Text("Masz w tej chwili ${tasks.length} zadań."),
                SizedBox(height: 20),
                Text("Wykonałeś ${tasks.where((task) => task.done).length} zadań."),
                SizedBox(height: 20),
                Text(
                  "Dzisiejsze zadania",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        Task task = tasks[index];
                        return TaskCard(
                          title: task.title,
                          subtitle: "Termin: ${task.deadline} | Priorytet: ${task.priority}",
                          icon: task.done
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class Task {
  final String title;
  final String deadline;
  bool done;
  String priority;

  Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });
}
