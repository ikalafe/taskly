import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;

  String? _newTaskContent;

  _HomePageState();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
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
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.connectionState == ConnectionState.done) {
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
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight * 0.05,
        horizontal: 26,
      ),
      children: [
        const Text(
          "Tasks:",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: _deviceHeight * 0.01),
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
            title: const Text(
              "Do Laundry!",
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Color.fromRGBO(245, 245, 245, 1.0),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              DateTime.now().toString(),
              style: const TextStyle(
                color: Color.fromRGBO(122, 119, 119, 1.0),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
      builder: (BuildContext _context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          title: const Text(
            "Add New Task!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: TextField(
            onSubmitted: (_value) {},
            onChanged: (_value) {
              setState(() {
                _newTaskContent = _value;
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
