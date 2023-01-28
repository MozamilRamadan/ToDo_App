import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class NewTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return   ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context) {
            return ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(tasks[index], context) ,
                separatorBuilder: (context, index) => myDivider(),
                itemCount: tasks.length);
          },
          fallback: (context) => Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu,
                size: 100,
                color: Colors.blueGrey,
              ),
              Text('No Tasks Yet, Please Add Some Tasks'),
            ],
          )),
        );
      },
      listener: (context, state) {

      },);

  }
}