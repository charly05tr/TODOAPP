import 'package:flutter/material.dart';

class Task {
  final String? id;
  final DateTime createdAt;
  String task;
  DateTime? endsAt;
  bool state;

  Task({
    this.id,
    required this.task,
    DateTime? createdAt,
    this.state = true,
    this.endsAt,
  }): createdAt = createdAt ?? DateTime.now();

  //metodo para converit la tarea a un mapa (util para enviar al servidor)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'createdAt': createdAt.toIso8601String(),
      'endsAt': endsAt?.toIso8601String(),
      'state': state, 
    };
  }

  // metodo para crear una tarea desde un mapa (util para recibir datos del servidor)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      task: map['task'],
      createdAt: DateTime.parse(map['createdAt']),
      endsAt: map['endsAt'] != null ? DateTime.parse(map['endsAt']) : null,
      state: map['state']
    );
  }
}

class TaskItem extends StatefulWidget {
   final Task task;
  final VoidCallback onStateChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.onStateChanged,
  });

   @override
  State<TaskItem> createState() => TaskItemState();
}

class TaskItemState extends State<TaskItem>{


  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        onTap: () {
          print({"task":task.task, 'created_at': task.createdAt, "state": task.state});
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Color.fromRGBO(20, 20, 20, 0.9),
        leading: Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            onPressed: () {
              setState(() {
                task.state = !task.state; // Cambia el estado interno
              });
              widget.onStateChanged();
            },
            icon: task.state
              ? Icon(Icons.circle_outlined)
              : Icon(Icons.check_circle),
            color: Color.fromRGBO(240, 240, 240, 0.9),
          ),
        ),
        title: Text(
          task.task, 
          style: 
            TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(240, 240, 240, 0.9),
              decoration: task.state ? TextDecoration.none : TextDecoration.lineThrough,
              decorationColor: Colors.red,
            )
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            color: Color.fromRGBO(240, 240, 240, 0.9),
            iconSize: 25,
            onPressed: () {},
            icon: Icon(Icons.star_border_outlined)),
        ),
      )
    ); 
  }
}
