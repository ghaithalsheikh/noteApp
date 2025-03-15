import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/cubit/task_copmeted_cubit.dart';
import 'package:note_app/cubit/task_cubit/task_cubit.dart';
import 'package:note_app/models/task_model.dart';

class TaskContainer extends StatelessWidget {
  const TaskContainer(
      {super.key,
      this.completed = false,
      required this.title,
      required this.dateTime,
      required this.idNotificataion});
  final String? title;
  final int idNotificataion;
  final String dateTime;
  final bool completed;
  @override
  Widget build(BuildContext context) {
    // Split the date and time parts
    List<String> dateTimeParts = dateTime.split(' ');
    String datePart = dateTimeParts[0]; // "2025-03-14"
    String timePart = dateTimeParts[1].replaceFirst('-', ':'); // "08:16"

    // Create a DateTime object from the parsed parts
    DateTime parsedDateTime = DateTime.parse('$datePart $timePart');

    bool isTaskExpired = parsedDateTime.isBefore(DateTime.now());

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double myContainerHeight = screenHeight * 0.1;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.012),
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenHeight * 0.007),
      height: myContainerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.04)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  completed
                      ? Icon(
                          Icons.check_box,
                          color: Colors.grey[600],
                        )
                      : IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(0),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // the '2023' part
                          ),
                          onPressed: () {
                            BlocProvider.of<TaskCubit>(context).removeItem(
                                listTaskModel: [
                                  TaskModel(
                                      idNotification: idNotificataion,
                                      title: title!,
                                      dateTime: dateTime)
                                ]);
                            BlocProvider.of<TaskCopmetedCubit>(context)
                                .addItemToComplated(
                                    taskModel: TaskModel(
                                        idNotification: idNotificataion,
                                        title: title!,
                                        dateTime: dateTime));
                          },
                          icon: Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.grey[600],
                          ))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!.isEmpty ? '' : title!,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    isTaskExpired ? 'انتهى موعد المهمة' : dateTime,
                    style: TextStyle(
                        fontSize: screenWidth * 0.03, color: Colors.grey),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
