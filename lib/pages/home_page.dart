import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;
  String? _newTaskContent;
  Box? _data;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _taskView(),
        floatingActionButton: _taskButton(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      toolbarHeight: _deviceHeight * 0.15,
      title: const Text(
        "Taskly!",
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      // future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _data = snapshot.data;
          return _taskList();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _taskList() {
    List tasks = _data!.values.toList();

    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = Task.fromMap(tasks[index]);
          return _taskItem(task, index);
        });
  }

  Widget _taskItem(Task task, int index) {
    return ListTile(
      title: Text(
        task.content,
        style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(task.timestamp.toString()),
      trailing: Icon(
        task.done
            ? Icons.check_box_outlined
            : Icons.check_box_outline_blank_outlined,
        color: Colors.red,
      ),
      onTap: () {
        task.done = !task.done;
        setState(() {
          _data!.putAt(index, task.toMap());
        });
      },
      onLongPress: () {
        setState(() {
          _data!.deleteAt(index);
        });
      },
    );
  }

  Widget _taskButton() {
    return FloatingActionButton(
      onPressed: _taskDialog,
      child: const Icon(Icons.add),
    );
  }

  void _taskDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add New Task!"),
            content: TextField(
              onSubmitted: (value) {
                if (_newTaskContent != null) {
                  Task task = Task(
                    content: _newTaskContent!,
                    timestamp: DateTime.now(),
                  );
                  setState(() {
                    _data!.add(task.toMap());
                    _newTaskContent = null;
                  });
                  Navigator.pop(context);
                }
              },
              onChanged: (value) {
                setState(() {
                  _newTaskContent = value;
                });
              },
              autofocus: true,
            ),
          );
        });
  }
}
