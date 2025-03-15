import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:note_app/models/task_model.dart';

part 'task_copmeted_state.dart';

class TaskCopmetedCubit extends Cubit<TaskCopmetedState> {
  Box<dynamic>? boxOfTaskComplated;
  TaskCopmetedCubit() : super(TaskCopmetedInitial()) {
    initialize();
  }
  Future<void> initialize() async {
    await openHiveBox(); // Open the Hive box
    getHomeListTaskComplated(); // Retrieve homeList from the Hive box
  }

  Future<void> openHiveBox() async {
    await Hive.initFlutter();
    // Await the openBox method
    boxOfTaskComplated = await Hive.openBox<dynamic>(
        'tasksCompleted'); // Await the openBox method
  }

  void getHomeListTaskComplated() async {
    if (boxOfTaskComplated != null) {
      List<TaskModel> homeListe = [];
      for (var i = 0; i < boxOfTaskComplated!.length; i++) {
        TaskModel value = boxOfTaskComplated!.getAt(i);

        homeListe.insert(0, value);
      }
      emit(TaskCopmetedSuccess(homeList: homeListe));
    }
  }

  void addItemToComplated({required TaskModel taskModel}) async {
    await boxOfTaskComplated?.add(taskModel);

    getHomeListTaskComplated();
  }

  void removeItem({required List<TaskModel> listTaskModel}) async {
    if (listTaskModel.isNotEmpty) {
      for (var item in listTaskModel) {
        for (var i = 0; i < boxOfTaskComplated!.length; i++) {
          TaskModel value = boxOfTaskComplated!.getAt(i);

          if (value.title == item.title && value.dateTime == item.dateTime) {
            await boxOfTaskComplated!.deleteAt(i);
          }
        }
      }
    }
    getHomeListTaskComplated();
  }
}
