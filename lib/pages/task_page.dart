import 'package:flutter/material.dart';
import '../widgets/todo_item.dart';


class TaskPage extends StatefulWidget {

  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  late Future<List<Task>> tasksFuture; // Variable para manejar las tareas

  @override
  void initState() {
    super.initState();
    tasksFuture = getTasks(); // Llama a la API al inicializar el widget
  }

  bool showCompleted = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay tareas disponibles.'));
          } else {

            List<Task> tasks = snapshot.data!;
            int completed = 0;
            for (Task task in tasks) {
              if (!task.state) {
                completed++;
              } 
            }
            return Scaffold(
              backgroundColor: Colors.transparent,
                body: Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    for (Task task in tasks)
                      if (task.state) 
                      TaskItem(
                        task: task,
                        onStateChanged: () {
                          setState(() {
                            task.state =
                                !task.state; // Cambia el estado de la tarea
                          });
                        },
                      ),
                    // boton para ver las tareas completadas
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showCompleted = !showCompleted; // Cambia el estado
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7), // Padding del botón
                        decoration: BoxDecoration(
                          color:
                              Color.fromRGBO(20, 20, 20, 0.6), // Fondo oscuro
                          borderRadius:
                              BorderRadius.circular(8), // Bordes redondeados
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
                              'Completadas $completed',
                              style: TextStyle(
                                color: Color.fromRGBO(240, 240, 240, 0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!showCompleted)
                    for (Task task in tasks)
                      if (!task.state) 
                      TaskItem(
                        task: task,
                        onStateChanged: () {
                          setState(() {
                            task.state =
                                !task.state; // Cambia el estado de la tarea
                          });
                        },
                      ),
                  ],
                )),
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
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(240, 240, 240, 0.9)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                setState(() {
                                  postTask(Task(task:controller.text));
                                  tasksFuture = getTasks();
                                  controller.clear();
                                  
                                });
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
            ));
          }
        });
  }
}
