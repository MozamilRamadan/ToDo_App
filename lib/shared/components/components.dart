import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../cubit/cubit.dart';


Widget buildTaskItem(Map model, context) {

  return Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          child: Text(
            '${model['time']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(width: 16.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
              SizedBox(height: 10),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.0,),
        IconButton(
            onPressed: (){
               AppCubit.get(context).updateData(status: 'done', id: model['id']);
            },
            icon: Icon(Icons.check_circle_sharp,
              color: Colors.green[600],
            )),
        SizedBox(width: 16.0,),
        IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status: 'archive', id: model['id']);
              // AppCubit.get(context).update();
            },
            icon: Icon(Icons.archive,
              color: Colors.black45,
            )),
      ],
    ),
  ),
  onDismissed: (direction) {
     AppCubit.get(context).deleteData(id: model['id'],);
  },
);}

Widget myDivider() => Container(
  width: double.infinity,
  height: 1.0,
  color: Colors.grey,
);

void showToast({
  required String text,
  required state,
})=>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ChosseColoer(state),
        textColor: Colors.white,
        fontSize: 16.0
    );

enum ToastState{SUCCESS, WARNING, ERROR}

Color ChosseColoer(ToastState state){
  Color color;
  switch(state){
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
    case ToastState.ERROR:
      color = Colors.red;
  }
  return color;
}
