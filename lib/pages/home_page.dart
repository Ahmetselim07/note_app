import 'package:flutter/material.dart';
import 'package:flutter_tuto/data/database.dart';
import 'package:flutter_tuto/util/dialog_box.dart';
import 'package:hive/hive.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _mybox = Hive.box('mybox');
   ToDoDatabase db = ToDoDatabase();

   @override
   void initState() {
    if(_mybox.get('TODOLIST') == null){
        db.createInitialData();
    }else{
      db.loadData();
    }
     super.initState();
     
   }

  TextEditingController _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: _controller,
        onSave: saveNewTask, // Burada fonksiyonu çağırmadan referansını veriyoruz.
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void deleteTask(int index){
    setState(() {
      db.todoList.removeAt(index);
      
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('TO DO'),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.todoList[index][0],
            taskCompleted: db.todoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
