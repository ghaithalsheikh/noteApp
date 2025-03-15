part of 'task_copmeted_cubit.dart';

@immutable
sealed class TaskCopmetedState {}

final class TaskCopmetedInitial extends TaskCopmetedState {}

final class TaskCopmetedSuccess extends TaskCopmetedState {
  final List<TaskModel> homeList;

  TaskCopmetedSuccess({required this.homeList});
}
