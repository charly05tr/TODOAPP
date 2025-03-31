import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_page.dart';
import '../main.dart';
import 'widgets/todo_item.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AppState>();
    List<Task> todoList = appState.todoList;
    List<Task> myDay = [];
    List<Task> myDayCompleted = [];

    for (Task task in todoList) {
      if (task.createdAt.day == DateTime.now().day) {
        myDay.add(task);
      }
    }
    for (Task task in appState.completed) {
      if (task.createdAt.day == DateTime.now().day) {
        myDayCompleted.add(task);
      }
    }
    return TaskPage(
      todoList: myDay,
      completed: myDayCompleted
    );
     
  }
}