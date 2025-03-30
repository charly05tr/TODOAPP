import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(),
      ),
    );
  }  
}

class MyAppState extends ChangeNotifier {
   var todoList = <String>[];

  void addTask(task) {
    todoList.insert(0, task);
    notifyListeners();
  }

  void finishTask(task) {
    var index = todoList.indexOf(task);
    todoList.removeAt(index);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch(selectedIndex) {
      case 0:
        page = Center(child: Text('Bienvenido'));
      case 1: 
        page = TaskPage();
      case 2:
        page = Center(child: Text('Perfil'));
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {

        return Scaffold(
          backgroundColor: Colors.white,
          body: page,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Inicio',
                icon: Icon(Icons.home),
              ),

              BottomNavigationBarItem(
                label: 'Tareas',
                icon: Icon(Icons.list),
              ),

              BottomNavigationBarItem(
                label: 'Perfil',
                icon: Icon(Icons.person),
              )

            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),

        );
      }
    );
  }
}

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var todoList = appState.todoList;

    final TextEditingController controller = TextEditingController();

    return Column(
     children: [
      Expanded(
        child: todoList.isEmpty
              ? Center(
                  child: Text('Agrega una nueva tarea.'),
                )
              : ListView(
                  children: [
                    for (var task in todoList)
                      ListTile(
                        leading: ElevatedButton.icon(
                          onPressed: () {
                            appState.finishTask(task);
                          },
                          icon: appState.todoList.contains(task)
                              ? Icon(Icons.circle_outlined)
                              : Icon(Icons.check_circle),
                          label: Text(task.toString()),
                        ),
                      )
                  ],
                ),
        ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Agregar una tarea',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  appState.addTask(controller.text);
                  controller.clear();
                }
             }, 
              icon: Icon(Icons.add)
            )
          )
        ),
      ),
      SizedBox(height: 20,)
          
     ],
    ); 
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
  });

  final String task;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme =  Theme.of(context);

    return Card(
      color: theme.colorScheme.onPrimary,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            appState.finishTask(task);
          },
          icon: appState.todoList.contains(task)
                ? Icon(Icons.circle_outlined)
                : Icon(Icons.check_circle),
          label: Text(task.toString()),
        ),
      ),
    );
  }
}