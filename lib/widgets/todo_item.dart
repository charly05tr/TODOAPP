import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Task {
  final int? id;
  final DateTime createdAt;
  String task;
  DateTime ?endsAt;
  bool state;

  Task({
    this.id,
    required this.task,
    DateTime? createdAt,
    this.state = true,
    this.endsAt
  }): createdAt = createdAt ?? DateTime.now();

  //metodo para convertir la tarea a un mapa (util para enviar al servidor)
  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'ends_at': '2025-12-31',
      'state': 'P',
      'priority': 'M',
      'user': 2
    };
  }

  // metodo para crear una tarea desde un mapa (util para recibir datos del servidor)
  factory Task.fromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'],
    task: map['task'],
    createdAt: DateTime.parse(map['created_at']),
    endsAt: map['ends_at'] != null ? DateTime.parse(map['ends_at']) : null,
    state: map['state'] == 'P' ? true : false,
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
            onPressed: () async {
      // Cambiar el estado en el servidor
      await patchState(task);

      // Notificar al widget padre para que recargue tareas desde la API
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

Future<List<Task>> getTasks() async {
  final response = await http.get(
    Uri.parse('https://restapitodoapp.onrender.com/api/tasks/'),
     headers: {
      'Authorization': 'token e9b1a0020038ff5224bd89d32e96e4f16f0d7a50', 
    },
  );

  if (response.statusCode == 200) {
    // Decodifica el JSON y convierte cada elemento en una instancia de Task
    List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((task) => Task.fromMap(task as Map<String, dynamic>)).toList();
  } else {
    // Si el servidor no devuelve un 200 OK, lanza una excepción
    throw Exception('Failed to load tasks');
  }
}


patchState(task) async {
  final response = await http.patch(
    Uri.parse('https://restapitodoapp.onrender.com/api/tasks/${task.id}/'),
    headers: {
      'Authorization': 'token e9b1a0020038ff5224bd89d32e96e4f16f0d7a50',  
       'Content-Type': 'application/json', 
    },
    body: 
      jsonEncode({
      'state': task.state ? 'P': 'T'
      })
  ); 
  print(response.statusCode);
  return response.statusCode;
}

postTask(task) async {
  final response = await http.post(
    Uri.parse('https://restapitodoapp.onrender.com/api/create-task'),
    headers: {
       'Authorization': 'token e9b1a0020038ff5224bd89d32e96e4f16f0d7a50', 
       'Content-Type': 'application/json', 
    },
    body: jsonEncode(task.toMap())
  );
  print(response.statusCode);
  print(jsonEncode(task.toMap()));
  return response.statusCode;
}