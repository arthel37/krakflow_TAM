import 'package:flutter/material.dart';
import 'models/task.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../services/task_sync_service.dart';
import '../services/task_local_database.dart';
import 'dart:math';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("tasks");

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
  final GlobalKey<_TaskListScreenState> _taskListKey =
      GlobalKey<_TaskListScreenState>();

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
              Text(
                "Dzisiejsze zadania",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: TaskListScreen(key: _taskListKey),
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
                  EditTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
          if (newTask != null) {
            await TaskLocalDatabase.addTask(newTask);
            _taskListKey.currentState?.refreshList();
          }
        },
        child: Icon(Icons.add),
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
    tasksFuture = loadTasks();
  }

  Future<List<Task>> loadTasks() async {
    await TaskSyncService.loadInitialDataIfNeeded();
    return TaskLocalDatabase.getTasks();
  }

  Future<void> addTask(Task task) async {
    await TaskLocalDatabase.addTask(task);
    await loadTasks();
  }

  void refreshList() {
    setState(() {
      tasksFuture = loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Błąd: ${snapshot.error}"));
        }

        final tasks = snapshot.data ?? [];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[index];
            return TaskCard(
              title: task.title,
              subtitle:
                  "Termin: ${task.deadline} | Priorytet: ${task.priority}",
              icon: task.done
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              onChanged: (value) async {
                final updatedTask = Task(
                  id: task.id,
                  title: task.title,
                  deadline: task.deadline,
                  priority: task.priority,
                  done: value,
                );

                await TaskLocalDatabase.updateTask(updatedTask);

                setState(() {
                  tasksFuture = loadTasks();
                });
              },
              onTap: () async {
                final Task? updatedTask = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(currTask: task),
                  ),
                );
                if (updatedTask != null) {
                  await TaskLocalDatabase.updateTask(updatedTask);
                  setState(() {
                    tasksFuture = loadTasks();
                  });
                }
              },
            );
          },
        );
      },
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final Task? currTask;

  const EditTaskScreen({super.key, this.currTask});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController deadlineController;
  late TextEditingController priorityController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.currTask?.title ?? '');
    deadlineController = TextEditingController(
      text: widget.currTask?.deadline ?? '',
    );
    priorityController = TextEditingController(
      text: widget.currTask?.priority ?? '',
    );
  }

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
                  id: widget.currTask?.id ?? Random().nextInt(1000000),
                  title: titleController.text,
                  deadline: deadlineController.text,
                  priority: priorityController.text,
                  done: widget.currTask?.done ?? false,
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
