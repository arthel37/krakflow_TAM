import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrakFlow',
      home: Scaffold(body: Center(child: Column(
        children: [
          Text("KrakFlow"),
          SizedBox(height: 20,),
          Text("Organizacja studiów"),
          SizedBox(height: 20,),
          Text("Dzisiejsze zadania"),
          TaskCard(
              title: "Projekt Flutter",
              subtitle: "Termin: jutro",
              icon: Icons.task),
          TaskCard(
              title: "Ćwiczenia z matematyki",
              subtitle: "Termin: dzisiaj",
              icon: Icons.task),
          TaskCard(
              title: "Przeczytać o widgetach",
              subtitle: "Termin: w tym tygodniu",
              icon: Icons.task)
      ])),
          floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add)))
    );
  }
}

class TaskCard extends StatelessWidget{
  final String title;
  final String subtitle;
  final IconData icon;

  TaskCard({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}