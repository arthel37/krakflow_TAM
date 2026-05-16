import 'package:flutter/material.dart';
import './task_repository.dart';
import './task.dart';
import 'task_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'KrakFlow', home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KrakFlow")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text("Masz w tej chwili ${TaskRepository.tasks.length} zadań."),
              //SizedBox(height: 20),
              //Text(
              //  "Wykonałeś ${TaskRepository.tasks.where((task) => task.done).length} zadań.",
              //),
              //SizedBox(height: 20),
              Text(
                "Dzisiejsze zadania",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: TaskListScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
          if (newTask != null) {
            setState(() {
              TaskRepository.tasks.add(newTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nowe zadanie")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Tytuł",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: TextField(
                controller: deadlineController,
                decoration: InputDecoration(
                  labelText: "Deadline",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: TextField(
                controller: priorityController,
                decoration: InputDecoration(
                  labelText: "Priorytet",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                  priority: priorityController.text,
                  done: false,
                );
                Navigator.pop(context, newTask);
              },
              child: Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = TaskApiService.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasksFuture,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError){
          return Center(
            child: Text("Błąd: ${snapshot.error}"),
          );
        }

        final tasks = snapshot.data!;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index){
            Task task = tasks[index];
            return TaskCard(
                title: task.title,
                subtitle:
                "Termin: ${task.deadline} | Priorytet: ${task.priority}",
                icon: task.done
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked
            );
          },
        );
      },
    );
  }
}