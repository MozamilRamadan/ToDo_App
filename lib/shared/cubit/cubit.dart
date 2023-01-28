import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_pp/shared/cubit/states.dart';

import '../../modules/archive_task/archive_task.dart';
import '../../modules/done_task/done_task.dart';
import '../../modules/new_task/new_task.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialStates());
  static AppCubit get(context) => BlocProvider.of(context);

  Database? database;
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> archivedTasks = [];
  List<Map> doneTasks = [];
  List<String> title =[
    'New Task',
    'Done Task',
    'Archive Task',
  ];

  List<Widget> screens=[
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];


  void changeIndex(int index) {
    currentIndex = index;
    emit(AppBottomNavBar());}


  IconData fabeIcon = Icons.edit;
  bool isBottomShown = false;
  void changeButtonSheetState({
    required IconData icon,
    required bool isShow,
  }){
    fabeIcon = icon;
    isBottomShown = isShow;
    emit(AppChangeBottomSheetState());
  }

  //=======================================================================
//
  void createDatabase()async{
    database = await openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version){
          print('Database Created');

          database.execute('CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT, date TEXT,  time TEXT, status TEXT)').
          then((value){
            print('Table Created');
          }).
          catchError((e){});
        },

        onOpen: (database){
          getDataFromDatabase(database);
          print('database Opened');
        });
  }


  Future insertToDatabase({
    required String time,
    required String date,
    required String title,
  })async{
    return await database!.transaction((txn)async{
       txn.rawInsert('INSERT INTO task(title,date,time,status) VALUES ("$title","$date","$time","New")').
      then((value){
        print('$value Inserted Successfully');
        getDataFromDatabase(database);
      }).
      catchError((error){
        print('while Row Inserting ${error.toString()}');});
      return null;
    });
  }

  void getDataFromDatabase(database){
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetFromDatabaseLoadingState());
    database.rawQuery('SELECT * From task').then((value){
      value.forEach((element){
        if(element['status']== 'New')
          newTasks.add(element);
        else if(element['status'] == 'archive')
          archivedTasks.add(element);
        else doneTasks.add(element);
      });
      emit(AppGetFromDatabaseSuccessState());
    }).
    catchError((error){
      print('while Getting Data ${error.toString()}');
    });
  }

  void updateData({
  required String status,
    required int id
})async {
    database!.rawUpdate(
      'UPDATE task SET status = ? WHERE id = ?',
      [status, id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({required int id})async{

     database!.rawDelete(
         'DELETE FROM task WHERE id = ?', [id]
     ).then((value){

      getDataFromDatabase(database);
      emit(AppDeleteFromDatabaseSuccessState());
      print('$value Is Deleted Successfully');
    });
  }
}