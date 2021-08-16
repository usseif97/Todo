import 'package:bloc/bloc.dart';
import 'package:bmi_calculator/shared/components/components.dart';
import 'package:bmi_calculator/shared/cubit/cubit.dart';
import 'package:bmi_calculator/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState)
            Navigator.pop(context); // close bottomSheet, Drawer, ...
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print('isBottomSheet: ${cubit.isBottomSheet}');
                if (cubit.isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  print('isBottomSheet: ${cubit.isBottomSheet}');
                  titleController.text = "";
                  timeController.text = "";
                  dateController.text = "";
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            color: Colors.grey[200],
                            padding: const EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        controller: titleController,
                                        type: TextInputType.text,
                                        validate: (value) {
                                          if (value!.isEmpty)
                                            return 'title cannot be empty !';
                                          return null;
                                        },
                                        label: 'Task Title',
                                        prefix: Icons.title,
                                      ),
                                      SizedBox(height: 10),
                                      defaultFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        showKeyboard: false,
                                        validate: (value) {
                                          if (value!.isEmpty)
                                            return 'time cannot be empty !';
                                          return null;
                                        },
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            if (value != null)
                                              timeController.text = value
                                                  .format(context)
                                                  .toString();
                                          });
                                        },
                                        label: 'Task Time',
                                        prefix: Icons.watch_later_outlined,
                                      ),
                                      SizedBox(height: 10),
                                      defaultFormField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        showKeyboard: false,
                                        validate: (value) {
                                          if (value!.isEmpty)
                                            return 'date cannot be empty !';
                                          return null;
                                        },
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2025-05-03'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!)
                                                    .toString();
                                          });
                                        },
                                        label: 'Task Date',
                                        prefix: Icons.calendar_today,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
            body: state is AppGetDatabaseLoadingState /*tasks.length == 0*/
                ? Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentIndex],
            /*ConditionalBuilder(
            condition: tasks.length > 0,
            builder: (context) => _screens[_currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),*/
          );
        },
      ),
    );
  }
}
