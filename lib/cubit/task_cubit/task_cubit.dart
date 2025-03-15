import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:note_app/hive/task_list_hive.dart';
import 'package:note_app/models/task_model.dart';

part 'task_cubit_state.dart';

class TaskCubit extends Cubit<TaskCubitState> {
  Box<dynamic>? box;
  // Box<dynamic>? boxOfTaskComplated;
  TaskCubit() : super(TaskCubitInitial()) {
    initialize();
  }
  Future<void> initialize() async {
    await openHiveBox(); // Open the Hive box
    getHomeList(); // Retrieve homeList from the Hive box
  }

  Future<void> openHiveBox() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter()); // Register the type adapter
    box = await Hive.openBox<dynamic>('tasks'); // Await the openBox method
    // boxOfTaskComplated = await Hive.openBox<dynamic>(
    //     'tasksCompleted'); // Await the openBox method
  }

  void getHomeList() async {
    if (box != null) {
      List<TaskModel> homeListe = [];
      for (var i = 0; i < box!.length; i++) {
        TaskModel value = box!.getAt(i);
        homeListe.insert(0, value);
      }
      emit(TaskCubitShowItem(homeList: homeListe));
    }
  }

  // void getHomeListTaskComplated() async {
  //   if (boxOfTaskComplated != null) {
  //     List<TaskModel> homeListe = [];
  //     for (var i = 0; i < boxOfTaskComplated!.length; i++) {
  //       TaskModel value = boxOfTaskComplated!.getAt(i);
  //       homeListe.insert(0, value);
  //     }
  //     emit(TaskCubitShowComplated(homeList: homeListe));
  //   }
  // }

  // void addItemToComplated({required TaskModel taskModel}) async {
  //   await boxOfTaskComplated?.add(taskModel);

  //   getHomeListTaskComplated();
  // }

  void addItem({required TaskModel taskModel}) async {
    await box?.add(taskModel);

    getHomeList();
  }

  void removeItem({required List<TaskModel> listTaskModel}) async {
    if (listTaskModel.isNotEmpty) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      for (var item in listTaskModel) {
        await flutterLocalNotificationsPlugin.cancel(item.idNotification);
        for (var i = 0; i < box!.length; i++) {
          TaskModel value = box!.getAt(i);

          if (value.title == item.title && value.dateTime == item.dateTime) {
            await box!.deleteAt(i);
          }
        }
      }
    }
    getHomeList();
  }

  void showContainerTextFeild() {
    emit(TaskCubitShowContainerTextFeild());
  }
}
