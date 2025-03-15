class TaskModel {
  final String title;
  final String dateTime;
  final int idNotification;

  TaskModel(
      {required this.idNotification,
      required this.title,
      required this.dateTime});
}
