import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Task Manager',
        isDarkMode: isDarkMode,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  final String title;
  final bool isDarkMode;
  final Function onThemeToggle;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _taskController = TextEditingController();
  // keeping track of tasks and status
  List<String> tasks = [];
  List<bool> isCompleted = [];

  void addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(_taskController.text);
        isCompleted.add(false);
        _taskController.clear();
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      isCompleted.removeAt(index);
    });
  }

  void toggleTask(int index) {
    setState(() {
      isCompleted[index] = !isCompleted[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeToggle();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Task name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: isCompleted[index],
                        onChanged: (bool? value) {
                          toggleTask(index);
                        },
                      ),
                      title: Text(tasks[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteTask(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}