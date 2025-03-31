import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/todo_item.dart';
import '../main.dart';

class TaskPage extends StatefulWidget {
  final List<Task> todoList;
  final List<Task> completed;

  const TaskPage({
    super.key,
    required this.todoList,
    required this.completed
    });

  @override
  State<TaskPage> createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  bool showCompleted = false;
  @override
  Widget build(BuildContext context) {
    List<Task>todoList = widget.todoList;
    List<Task>completed = widget.completed;
    var appState = context.watch<AppState>();

    final TextEditingController controller = TextEditingController();

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: todoList.isEmpty && completed.isEmpty
              ? Center(
                  child: Text('Agrega una nueva tarea.'),
                )
              : ListView(
                  children: [
                    for (Task task in todoList)
                      TaskItem(
                        task: task,
                        onStateChanged: () {
                          appState.triggerTask(task);
                        },
                      ),
                    if (completed.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Botón para mostrar/ocultar tareas completadas

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showCompleted =
                                    !showCompleted; // Cambia el estado
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7), // Padding del botón
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    20, 20, 20, 0.6), // Fondo oscuro
                                borderRadius: BorderRadius.circular(
                                    8), // Bordes redondeados
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    showCompleted
                                        ? Icons
                                            .arrow_drop_up_sharp // Ícono cuando está desplegado
                                        : Icons
                                            .arrow_drop_down, // Ícono cuando está oculto
                                    color: Color.fromRGBO(240, 240, 240, 0.9),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Completadas ${appState.completed.length}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(240, 240, 240, 0.9),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (showCompleted)
                            for (Task task in completed)
                              TaskItem(
                                task: task,
                                onStateChanged: () {
                                  appState.triggerTask(task);
                                },
                              ),
                        ],
                      ),
                  ],
                ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Color.fromRGBO(20, 20, 20, 0.9),
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
              cursorColor: Colors.yellow,
              controller: controller,
              style: TextStyle(
                color: Color.fromRGBO(240, 240, 240, 0.9),
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                label: Text('Agregar una tarea'),
                labelStyle:
                    TextStyle(color: Color.fromRGBO(240, 240, 240, 0.9)),
                suffixIcon: IconButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        appState.addTask(controller.text);
                        controller.clear();
                      }
                    },
                    color: Color.fromRGBO(240, 240, 240, 0.9),
                    icon: Icon(Icons.add)),
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              )),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
