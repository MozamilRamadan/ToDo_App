import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_pp/modules/done_task/done_task.dart';
import '../modules/archive_task/archive_task.dart';
import '../modules/new_task/new_task.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class Home_Layout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return  BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {} ,
        builder: (context,  state) {
          var cubit =  AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('${cubit.title[cubit.currentIndex]}'),
            ),
            body:cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(

                onPressed: () {
                  if(cubit.isBottomShown){
                    if(formKey.currentState!.validate()){
                      cubit.insertToDatabase(
                        date: dateController.text,
                        time: timeController.text,
                        title: titleController.text,
                      ).then((value){
                        Navigator.pop(context);
                        cubit.changeButtonSheetState(icon:Icons.add_circle, isShow: true);
                      });

                    }
                  }else{
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                    (Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.grey[100],
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (String ?value){
                                if(value!.isEmpty){
                                  return '12';}
                                return null;
                              },
                              onTap: (){
                              },
                              controller: titleController,
                              decoration: InputDecoration(
                                label: Text('Title'),
                                prefixIcon:Icon(Icons.title),
                                border: OutlineInputBorder(),
                              ),

                            ),
                            const SizedBox(height: 14.0,),
                            //=========Time===============
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now()
                                ).then((value) {
                                  timeController.text= value!.format(context).toString(); }).catchError((error){
                                  print('Show Time Piker $error');
                                });
                              },
                              validator: (String ?value){
                                if(value!.isEmpty){
                                  return '12';}
                                return null;
                              },
                              controller: timeController,
                              decoration: InputDecoration(
                                label: Text('Time'),
                                prefixIcon:Icon(Icons.watch_later_rounded),
                                border: OutlineInputBorder(),
                              ),

                            ),
                            const SizedBox(height: 14.0,),
                            //=========Date================
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2025-09-15'),
                                ).then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value!);
                                }).catchError((error){print('From ShowDate $error');});

                              },
                              validator: (String ?value){
                                if(value!.isEmpty){
                                  return '12';}
                                return null;
                              },
                              controller: dateController,
                              decoration: InputDecoration(
                                label: Text('Date'),
                                prefixIcon:Icon(Icons.calendar_month_outlined),
                                border: OutlineInputBorder(),
                              ),

                            ),
                          ],
                        ),
                      ),
                    )),
                      elevation: 15,
                    ).closed.then((value) {
                      cubit.changeButtonSheetState(icon:Icons.edit, isShow: false);

                    });
                    cubit.changeButtonSheetState(icon:Icons.add , isShow: true);
                  }
                },
                child:  Icon(cubit.fabeIcon)
            ),

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeIndex(index);

              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Task',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_rounded),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}