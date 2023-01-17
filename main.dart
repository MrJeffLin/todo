import 'package:flutter/material.dart';
import 'task.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToDoPage(title: 'To-Do List'),
    );
  }
}

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key, required this.title});

  final String title;

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final List<task> _todoList = <task>[];
  final TextEditingController timeController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController duedateController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  bool isItemUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todoList.map((task todo) => _toDoList(todo)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => displayDialog(task()),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  Future<void> displayDialog(task todo) async {
    if (isItemUpdate) {
      textController.text = todo.name;
      detailController.text = todo.description;
      duedateController.text = todo.todoDate;
      timeController.text = todo.todoTime;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          children: [
            AlertDialog(
              title: const Text('Add or Edit a New Task'),
              content: Column(
                children: [
                  TextField(
                    controller: textController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task name'),
                  ),
                  TextField(
                    controller: detailController,
                    decoration:
                        const InputDecoration(hintText: 'Enter description'),
                  ),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(hintText: 'Enter time'),
                  ),
                  TextField(
                    controller: duedateController,
                    decoration:
                        const InputDecoration(hintText: 'Enter due date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    isItemUpdate = false;
                    clearControl();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    int index = isItemUpdate ? todo.itemNum : _todoList.length;

                    addItem(textController.text, detailController.text,
                        duedateController.text, timeController.text, index);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void addItem(String name, String description, String todoDate,
      String todoTime, int itemNum) {
    setState(() {
      if (isItemUpdate) {
        _todoList[itemNum].name = name;
        _todoList[itemNum].description = description;
        _todoList[itemNum].todoDate = todoDate;
        _todoList[itemNum].todoTime = todoTime;
        isItemUpdate = false;
      } else {
        _todoList.add(task(
            name: name,
            description: description,
            todoDate: todoDate,
            todoTime: todoTime,
            itemNum: itemNum));
      }
    });
    clearControl();
  }

  void clearControl() {
    duedateController.clear();
    detailController.clear();
    timeController.clear();
    textController.clear();
  }

  void deleteItem(task todo) {
    setState(() {
      _todoList.removeAt(todo.itemNum);
      for (int i = 0; i < _todoList.length; i++) {
        _todoList[i].itemNum = i;
      }
    });
  }

  Widget _toDoList(task todo) {
    return ListTile(
        leading: CircleAvatar(
          child: Text((todo.itemNum + 1).toString()),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(todo.name), Text(todo.description)],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo.todoDate),
                  Text(todo.todoTime),
                ],
              ),
            )
          ],
        ),
        trailing: Column(
          children: [
            GestureDetector(
              onTap: () {
                isItemUpdate = true;
                displayDialog(todo);
              },
              child: Icon(Icons.edit),
            ),
            GestureDetector(
              onTap: () {
                isItemUpdate = false;
                deleteItem(todo);
              },
              child: Icon(Icons.delete),
            )
          ],
        ));
  }
}
