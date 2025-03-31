import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/todo_item.dart';
import 'task_page.dart';
import 'home_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
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

class AppState extends ChangeNotifier {
  List<Task> todoList = [];
  List<Task> completed = [];
  
  void addTask(text) {
    Task task = Task(task: text);
    todoList.insert(0, task);
    notifyListeners();
  }

  void triggerTask(task) {
    var index = 0;

    if (todoList.contains(task)) {
      index = todoList.indexOf(task);
      todoList.removeAt(index);
      completed.insert(0, task);
    } 
    else {
      index = completed.indexOf(task);
      completed.removeAt(index);
      todoList.insert(index, task);
    }
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
    var appState = context.watch<AppState>();
    Widget page;
    switch(selectedIndex) {
      case 0:
        page = HomePage();
      case 1: 
        page = TaskPage(
          todoList: appState.todoList,
          completed: appState.completed,);
      case 2:
        page = Center(child: Text('Perfil'));
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
              )
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Hola, Carlos',
                style: TextStyle(color: Color.fromRGBO(240, 240, 240, 0.9))
                ),
              backgroundColor: Color.fromRGBO(20, 20, 20, 0.9),  
            ),
            backgroundColor: Colors.transparent,
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
              backgroundColor: Color.fromRGBO(20, 20, 20, 0.9),
              unselectedItemColor: Color.fromRGBO(240, 240, 240, 0.9),
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          
          ),
        );
      }
    );
  }
}
