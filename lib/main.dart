import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/task_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

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
        page = HomePage();
      case 1: 
        page = TaskPage();
      case 2:
        page = ProfilePage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
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
            backgroundColor: const Color.fromARGB(0, 255, 249, 249),
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


//https://restapitodoapp.onrender.com/api/tasks/
//https://restapitodoapp.onrender.com/api/users/
//https://restapitodoapp.onrender.com/api/register/
//https://restapitodoapp.onrender.com/api/token-auth/
//https://restapitodoapp.onrender.com/api/change-password/
//https://restapitodoapp.onrender.com/api/reset-password/
//https://restapitodoapp.onrender.com/apireset-password-confirm/