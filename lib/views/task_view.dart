import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/cubit/task_copmeted_cubit.dart';
import 'package:note_app/cubit/task_cubit/hidden_button_cubit.dart';
import 'package:note_app/cubit/task_cubit/task_cubit.dart';
import 'package:note_app/models/task_model.dart';
import 'package:note_app/widgets/task_add.dart';
import 'package:note_app/widgets/task_container.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  bool isSelectionMode = false;
  bool isHiddenAddButton = false;
  bool isHiddenCompleted = false;
  Set<int> selectedItemsTask = <int>{};

  List<TaskModel> listTaskModel = [];
  _selectAll({required List countOfItem}) {
    if (selectedItemsTask.length == countOfItem.length) {
      selectedItemsTask.clear();
    } else {
      selectedItemsTask.addAll(List.generate(countOfItem.length, (i) => i));
    }
    isSelectionMode = selectedItemsTask.isNotEmpty;
  }

  void _toggleSelection(int index, {required TaskModel taskModel}) {
    setState(() {
      if (selectedItemsTask.contains(index)) {
        selectedItemsTask.remove(index);
      } else {
        listTaskModel.add(taskModel);
        selectedItemsTask.add(index);
      }
      isSelectionMode = selectedItemsTask.isNotEmpty;
    });
  }

  _deleteSelected({required List<TaskModel> listTaskmodel}) {
    BlocProvider.of<TaskCubit>(context)
        .removeItem(listTaskModel: listTaskmodel);

    setState(() {
      isHiddenAddButton = false;
      selectedItemsTask.clear();
      isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSizeAddButton = screenWidth * 0.07;
    double fontSizeTitle = screenWidth * 0.06;
    double containerSizeOfAddNote = screenWidth * 0.18;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: ListView(
          children: [
            BlocBuilder<TaskCubit, TaskCubitState>(
                buildWhen: (previous, current) => current is TaskCubitShowItem,
                builder: (context, state) {
                  if (state is TaskCubitShowItem) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        isSelectionMode
                            ? AppBar(
                                centerTitle: true,
                                title:
                                    Text('${selectedItemsTask.length} مختارة'),
                                leading: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      selectedItemsTask.clear();
                                      isSelectionMode = false;
                                      isHiddenAddButton = false;
                                    });
                                  },
                                ),
                                actions: [
                                  IconButton(
                                    icon: selectedItemsTask.length ==
                                            state.homeList.length
                                        ? Icon(
                                            Icons.checklist_rtl_sharp,
                                            color: Colors.amber,
                                          )
                                        : Icon(
                                            Icons.checklist_rtl_sharp,
                                          ),
                                    onPressed: () {
                                      _selectAll(countOfItem: state.homeList);
                                      isHiddenAddButton = false;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            : AppBar(
                                elevation: 0,
                                centerTitle: true,
                                scrolledUnderElevation: 0,
                                title: Text(
                                  'مهام',
                                  style: TextStyle(fontSize: fontSizeTitle),
                                )),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.homeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                if (!isSelectionMode) {
                                  setState(() => isSelectionMode = true);
                                }
                                _toggleSelection(index,
                                    taskModel: TaskModel(
                                        idNotification: state
                                            .homeList[index].idNotification,
                                        title: state.homeList[index].title,
                                        dateTime:
                                            state.homeList[index].dateTime));
                              },
                              onTap: () {
                                if (selectedItemsTask.isEmpty) {
                                  isHiddenAddButton = false;
                                }
                                if (isSelectionMode) {
                                  _toggleSelection(index,
                                      taskModel: TaskModel(
                                          idNotification: state
                                              .homeList[index].idNotification,
                                          title: state.homeList[index].title,
                                          dateTime:
                                              state.homeList[index].dateTime));
                                }
                              },
                              child: Stack(
                                children: [
                                  TaskContainer(
                                    idNotificataion:
                                        state.homeList[index].idNotification,
                                    title: state.homeList[index].title,
                                    dateTime: state.homeList[index].dateTime,
                                  ),
                                  if (isSelectionMode)
                                    Positioned(
                                      right: 20,
                                      top: 25,
                                      child: Checkbox(
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: Colors.amber,
                                        value:
                                            selectedItemsTask.contains(index),
                                        onChanged: (_) => _toggleSelection(
                                            index,
                                            taskModel: TaskModel(
                                                idNotification: state
                                                    .homeList[index]
                                                    .idNotification,
                                                title:
                                                    state.homeList[index].title,
                                                dateTime: state
                                                    .homeList[index].dateTime)),
                                      ),
                                    )
                                  else
                                    SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<TaskCopmetedCubit>(context)
                          .getHomeListTaskComplated();
                      if (isHiddenCompleted) {
                        isHiddenCompleted = false;
                      } else {
                        isHiddenCompleted = true;
                      }
                      setState(() {});
                    },
                    icon: isHiddenCompleted
                        ? Icon(Icons.keyboard_arrow_up_outlined)
                        : BlocBuilder<TaskCopmetedCubit, TaskCopmetedState>(
                            buildWhen: (previous, current) =>
                                current is TaskCopmetedSuccess,
                            builder: (context, state) {
                              if (state is TaskCopmetedSuccess) {
                                return Icon(Icons.keyboard_arrow_down_outlined);
                              }
                              return Icon(Icons.keyboard_arrow_down_outlined);
                            },
                          )),
                Text('Completed')
              ],
            ),
            !isHiddenCompleted
                ? BlocBuilder<TaskCopmetedCubit, TaskCopmetedState>(
                    buildWhen: (previous, current) =>
                        current is TaskCopmetedSuccess,
                    builder: (context, state) {
                      if (state is TaskCopmetedSuccess) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.homeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        'هل تريد حذف هذه المهمة ؟',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            'لا',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.04),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'نعم',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.04),
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<TaskCopmetedCubit>(
                                                    context)
                                                .removeItem(listTaskModel: [
                                              TaskModel(
                                                idNotification: state
                                                    .homeList[index]
                                                    .idNotification,
                                                title:
                                                    state.homeList[index].title,
                                                dateTime: state
                                                    .homeList[index].dateTime,
                                              )
                                            ]);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Stack(
                                children: [
                                  TaskContainer(
                                    completed: true,
                                    idNotificataion:
                                        state.homeList[index].idNotification,
                                    title: state.homeList[index].title,
                                    dateTime: state.homeList[index].dateTime,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return SizedBox();
                    },
                  )
                : SizedBox()
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton:
            BlocBuilder<HiddenButtonTaskCubit, HiddenButtonState>(
          builder: (context, state) {
            if (state is HiddenButtonTask) {
              if (state.isHidden == true) {
                return TaskAdd();
              }
              if (state.isHidden == false) {
                return isHiddenAddButton
                    ? SizedBox()
                    : Container(
                        width: containerSizeOfAddNote,
                        height: containerSizeOfAddNote,
                        margin: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            bottom: screenHeight * 0.05),
                        child: FloatingActionButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.9),
                            ),
                            backgroundColor: Colors.amber[600],
                            child: Icon(Icons.add,
                                color: Colors.black, size: iconSizeAddButton),
                            onPressed: () {
                              BlocProvider.of<HiddenButtonTaskCubit>(context)
                                  .hiddenAddButton = true;
                              BlocProvider.of<HiddenButtonTaskCubit>(context)
                                  .hiddenButton();
                            }),
                      );
              }
            }
            return isHiddenAddButton
                ? SizedBox()
                : Container(
                    width: containerSizeOfAddNote,
                    height: containerSizeOfAddNote,
                    margin: EdgeInsets.only(
                        left: screenWidth * 0.05, bottom: screenHeight * 0.05),
                    child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.9),
                        ),
                        backgroundColor: Colors.amber[500],
                        child: Icon(Icons.add,
                            color: Colors.black, size: iconSizeAddButton),
                        onPressed: () {
                          BlocProvider.of<HiddenButtonTaskCubit>(context)
                              .hiddenAddButton = true;
                          BlocProvider.of<HiddenButtonTaskCubit>(context)
                              .hiddenButton();
                        }),
                  );
          },
        ),
        bottomNavigationBar: isSelectionMode
            ? BottomAppBar(
                child: Column(
                  children: [
                    IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(0),
                      style: const ButtonStyle(
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // the '2023' part
                      ),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 32,
                      ),
                      onPressed: () {
                        _deleteSelected(listTaskmodel: listTaskModel);
                      },
                      color: Colors.white,
                    ),
                    Text('حذف')
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
