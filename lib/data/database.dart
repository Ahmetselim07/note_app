import 'package:hive/hive.dart';

class ToDoDatabase{
  List todoList = [];
  // reference our box
  final _mybox = Hive.box('mybox');

  void createInitialData(){
    todoList = [
      ['Make Tutorial',false],
      ['Do Exercise',false],
    ];
  }

  void loadData(){
    todoList = _mybox.get('TODOLIST');
  }

  void updateDatabase(){
    _mybox.put('TODOLIST', todoList);
  }
}