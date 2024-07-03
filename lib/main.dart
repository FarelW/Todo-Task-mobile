import 'package:flutter/material.dart';
import 'api_service.dart';
import 'task.dart';
import 'package:intl/intl.dart';
import 'form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'none';
  late Future<List<Task>> futureTasks;
  List<Task> _currentTasks = [];

  @override
  void initState() {
    super.initState();
    futureTasks = ApiService.fetchTasks();
    _loadInitialTasks();
  }

  Future<void> _loadInitialTasks() async {
    _currentTasks = await ApiService.fetchTasks();
    setState(() {});
  }

  void _refetchTasks() async {
    final newTasks = await ApiService.fetchTasks(
      search: _searchController.text,
      filter: _filter,
      offset: 0,
      limit: 10,
    );
    setState(() {
      _currentTasks = newTasks;
    });
  }

  void _handleSubmit(String title, String description, String dueDateString) async {
    DateTime dueDate = DateTime.parse(dueDateString); // Parse the string to DateTime
    await ApiService.addTask(title, description, dueDate);
    _refetchTasks();
  }

  Future<void> _handleMarkDone(Task task) async {
    await ApiService.markDone(task.id);
    _refetchTasks();
  }

  Future<void> _handleMarkUndone(Task task) async {
    await ApiService.markUndone(task.id);
    _refetchTasks();
  }

  Future<void> _handleDelete(Task task) async {
    await ApiService.deleteTask(task.id);
    _refetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 66, 2, 156),
              Color(0xFF15162c),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              'Todo List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.white), // Hint text color
                        filled: true,
                        fillColor: Colors.transparent, // Make the background transparent
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white), // Text color
                      onChanged: (value) {
                        _refetchTasks();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding inside the container
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filter,
                        items: const [
                          DropdownMenuItem(
                            value: 'none',
                            child: Text('None', style: TextStyle(color: Colors.white)),
                          ),
                          DropdownMenuItem(
                            value: 'done',
                            child: Text('Completed', style: TextStyle(color: Colors.white)),
                          ),
                          DropdownMenuItem(
                            value: 'undone',
                            child: Text('Not Completed', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filter = value!;
                            _refetchTasks();
                          });
                        },
                        dropdownColor: Colors.grey[800], // Background color for dropdown items
                        style: const TextStyle(color: Colors.white), // Text color
                        iconEnabledColor: Colors.white, // Icon color
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskFormScreen(onSubmit: _handleSubmit),
                          ),
                        );
                      },
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _currentTasks.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _currentTasks.length,
                      itemBuilder: (context, index) {
                        final task = _currentTasks[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(task.title, style: const TextStyle(color: Colors.white)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.description ?? 'No description', style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text(
                                  'Due Date: ${task.duedate != null ? DateFormat('yyyy-MM-dd').format(task.duedate!) : 'No Due Date'}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                task.isDone
                                    ? TextButton(
                                        onPressed: () => _handleMarkUndone(task),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white, // Text color
                                          backgroundColor: Colors.red, // Button background color
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0), // Less rounded
                                          ),
                                        ),
                                        child: const Text(
                                          'Mark as Undone',
                                          style: TextStyle(fontSize: 10, color: Colors.white),
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () => _handleMarkDone(task),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white, // Text color
                                          backgroundColor: Colors.green, // Button background color
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0), // Less rounded
                                          ),
                                        ),
                                        child: const Text(
                                          'Mark as Done',
                                          style: TextStyle(fontSize: 10, color: Colors.white),
                                        ),
                                      ),
                                Container(
                                  width: 36, // Set a fixed width for the container
                                  height: 36, // Set a fixed height for the container
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: IconButton(
                                    iconSize: 20, // Make the icon smaller
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _handleDelete(task),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 30), // Margin at the bottom
          ],
        ),
      ),
    );
  }
}
