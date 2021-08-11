import 'package:bmi_calculator/shared/components/components.dart';
import 'package:bmi_calculator/shared/components/constants.dart';
import 'package:bmi_calculator/shared/cubit/cubit.dart';
import 'package:bmi_calculator/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        AppCubit cubit = AppCubit.get(context);
        return cubit.newTasks.length > 0
            ? ListView.separated(
                itemBuilder: (context, index) =>
                    defaultTaskItem(cubit.newTasks[index], context),
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                itemCount: cubit.newTasks.length,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 50.0,
                    ),
                    Text(
                      'No Tasks !!',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
