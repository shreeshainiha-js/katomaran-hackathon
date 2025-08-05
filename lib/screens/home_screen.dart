import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins',
      ),
      home: const Placeholder(), // Replace with your Login/Home logic
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final List<Map<String, dynamic>> _tasks = [];
  String _filter = 'All';
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _filter = ['All', 'Open', 'Completed'][_tabController.index];
      });
    });
    super.initState();
  }

  void _addOrEditTask({Map<String, dynamic>? task, int? index}) async {
    final titleController = TextEditingController(text: task?['title']);
    final descController = TextEditingController(text: task?['description']);
    DateTime? dueDate = task?['dueDate'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task == null ? 'Add New Task' : 'Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => dueDate = pickedDate);
                  }
                },
                child: Text(
                  dueDate == null
                      ? 'Pick Due Date'
                      : 'Due: ${DateFormat.yMMMd().format(dueDate!)}',
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty || dueDate == null) return;
              final newTask = {
                'title': titleController.text.trim(),
                'description': descController.text.trim(),
                'completed': task?['completed'] ?? false,
                'dueDate': dueDate,
              };
              setState(() {
                if (task != null && index != null) {
                  _tasks[index] = newTask;
                } else {
                  _tasks.insert(0, newTask);
                }
              });
              Navigator.pop(context);
            },
            child: Text(task == null ? 'Add' : 'Update'),
          )
        ],
      ),
    );
  }

  void _toggleComplete(int index) {
    setState(() => _tasks[index]['completed'] = !_tasks[index]['completed']);
  }

  void _deleteTask(int index) {
    setState(() => _tasks.removeAt(index));
  }

  List<Map<String, dynamic>> get _filteredTasks {
    return _tasks.where((task) {
      final matchSearch = task['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (_filter == 'Open') return matchSearch && !task['completed'];
      if (_filter == 'Completed') return matchSearch && task['completed'];
      return matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${widget.user.displayName?.split(" ")[0] ?? 'User'}"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Open'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(child: Text("No tasks match your filters."))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          decoration: task['completed'] ? TextDecoration.lineThrough : null,
                          color: task['completed'] ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        "${task['description']}\nDue: ${DateFormat.yMMMd().format(task['dueDate'])}",
                        style: TextStyle(
                          color: task['completed'] ? Colors.grey : Colors.black54,
                        ),
                      ),
                      isThreeLine: true,
                      leading: Icon(
                        task['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task['completed'] ? Colors.green : Colors.grey,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _addOrEditTask(task: task, index: _tasks.indexOf(task)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(_tasks.indexOf(task)),
                          ),
                        ],
                      ),
                      onTap: () => _toggleComplete(_tasks.indexOf(task)),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditTask(),
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),
    );
  }
}
