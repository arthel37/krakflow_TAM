import './task.dart';

class TaskRepository {
  static final List<Task> tasks = [
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
}