part of 'task_cubit.dart';

@immutable
sealed class TaskCubitState {}

final class TaskCubitInitial extends TaskCubitState {}

final class TaskCubitShowItem extends TaskCubitState {
  final List<TaskModel> homeList;

  TaskCubitShowItem({required this.homeList});
}

final class TaskCubitShowComplated extends TaskCubitState {
  final List<TaskModel> homeList;

  TaskCubitShowComplated({required this.homeList});
}

final class TaskCubitShowContainerTextFeild extends TaskCubitState {}
