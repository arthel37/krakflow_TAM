
import 'dart:convert';
import 'package:http/http.dart' as http;
import './task.dart';
import 'dart:math';

String getRandomPriority() {
  final random = Random();
  final priorities = ["Niski", "Średni", "Wysoki"];
  return priorities[random.nextInt(priorities.length)];
}

String getRandomDeadline(){
  final random = Random();
  final deadlines = ["Dziś", "Jutro", "Pojutrze", "Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela"];
  return deadlines[random.nextInt(deadlines.length)];
}

class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";

  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse("$baseUrl/todos"), );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List todos = data["todos"];

      return todos.map((todo) {
        return Task(title: todo["todo"],
            deadline: getRandomDeadline(),
            done: todo["completed"],
            priority: getRandomPriority());
      }).toList();
    } else {
      throw Exception("Błąd pobierania danych");
    }
  }
}

