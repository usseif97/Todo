import 'package:bloc/bloc.dart';
import 'package:bmi_calculator/modules/archivedTasks/archived_tasks_screen.dart';
import 'package:bmi_calculator/modules/doneTasks/done_tasks_screen.dart';
import 'package:bmi_calculator/modules/newTasks/new_tasks_screen.dart';
import 'package:bmi_calculator/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNAVbarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database Created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('task Table Created');
        }).catchError((error) {
          print('Error while creating the table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('Database Opened');
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase({
    required title,
    required time,
    required date,
  }) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
            .then((value) {
          print('$value inserted successfully');
          emit(AppInsertDatabaseState());

          getDataFromDatabase(database);
        }).catchError((error) {
          print('Error while inserting the table ${error.toString()}');
        }));
  }

  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    // List<Map>
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') newTasks.add(element);
        if (element['status'] == 'done') doneTasks.add(element);
        if (element['status'] == 'archive') archivedTasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({required String status, required int id}) {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({required int id}) {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheet = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheet = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
