import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;

  String? _newTaskContent;

  Box? _box;
  _HomePageState();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: const Color.fromRGBO(10, 182, 171, 1.0),
        toolbarHeight: _deviceHeight * 0.08,
        title: const Text(
          "Taskly",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      ),
      floatingActionButton: _addTaskButton(),
      body: _tasksView(),
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _tasksList();
        } else {
          return SizedBox(
            height: _deviceHeight * 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please Wait',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: _deviceHeight * 0.03,
                  ),
                  const CircularProgressIndicator(
                    color: Color.fromRGBO(10, 182, 171, 1.0),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _tasksList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return Container(
          margin: EdgeInsets.only(
            top: _deviceHeight * 0.03,
            left: _deviceHeight * 0.01,
            right: _deviceHeight * 0.01,
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(32, 31, 31, 1.0),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius: 3,
                offset: const Offset(0.2, 0.5),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              task.content,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
                decorationColor: const Color.fromRGBO(122, 119, 119, 1.0),
                decorationThickness: 2,
                color: task.done
                    ? const Color.fromRGBO(122, 119, 119, 1.0)
                    : const Color.fromRGBO(245, 245, 245, 1.0),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              task.timestamp.toString(),
              style: const TextStyle(
                color: Color.fromRGBO(122, 119, 119, 1.0),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              task.done ? Icons.check_circle_outline : Icons.circle_outlined,
              color: task.done
                  ? const Color.fromRGBO(122, 119, 119, 1.0)
                  : Colors.white,
            ),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(
                index,
                task.toMap(),
              );
              setState(() {});
            },
            onLongPress: () {
              _box!.deleteAt(index);
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      backgroundColor: const Color.fromRGBO(10, 182, 171, 1.0),
      child: const Icon(
        Icons.add,
        color: Colors.black,
      ),
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          title: const Text(
            "Add New Task!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: TextField(
            onSubmitted: (_) {
              if (_newTaskContent != null) {
                var task = Task(
                    content: _newTaskContent!,
                    timestamp: DateTime.now(),
                    done: false);
                _box!.add(task.toMap());
                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (value) {
              setState(() {
                _newTaskContent = value;
              });
            },
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(10, 182, 171, 1.0),
                  width: 2.0,
                ),
              ),
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
