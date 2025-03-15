import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' as intl;
import 'package:note_app/cubit/task_cubit/hidden_button_cubit.dart';
import 'package:note_app/cubit/task_cubit/task_cubit.dart';
import 'package:note_app/models/task_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskAdd extends StatefulWidget {
  const TaskAdd({super.key});

  @override
  State<TaskAdd> createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {
  TextEditingController controller = TextEditingController();
  BoardDateTimeController boardDateTimeController = BoardDateTimeController();
  final FocusNode _focusNode = FocusNode();
  TextDirection currentTextDirection = TextDirection.rtl;
  double fontsize = 16;
  DateTime _selectedDateTime = DateTime.now();
  bool isSelcetedDateTime = false;
  bool isWriteTask = false;
  String? dateTime;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    await Permission.notification.request();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/note');

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'تذكير',
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  int notificationId = 1;
  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDateTime) async {
    final scheduledTime = tz.TZDateTime.from(scheduledDateTime, tz.local);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'reminder_channel', // id
            'تذكير',
            importance: Importance.max,
            playSound: true,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId++,
      title,
      body,
      scheduledTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  void showDateTimePicker() async {
    final DateTime? selected = await showBoardDateTimePicker(
      controller: boardDateTimeController,
      options: BoardDateTimeOptions(actionButtonTypes: []),
      context: context,
      initialDate: _selectedDateTime,
      minimumDate: DateTime.now(),
      maximumDate: DateTime(2100),
      pickerType: DateTimePickerType.datetime,
    );

    if (selected != null && selected != _selectedDateTime) {
      setState(() {
        isSelcetedDateTime = true;
        dateTime = intl.DateFormat('yyyy-MM-dd HH-mm').format(selected);
        _selectedDateTime = selected;
      });
    }
  }

  resetDatetime() {
    isSelcetedDateTime = false;
    dateTime == null;
    setState(() {});
  }

  handleTapOutside() {
    BlocProvider.of<HiddenButtonTaskCubit>(context).hiddenAddButton = false;
    BlocProvider.of<HiddenButtonTaskCubit>(context).hiddenButton();
  }

  addTask() {
    BlocProvider.of<TaskCubit>(context).addItem(
        taskModel: TaskModel(
            title: controller.text,
            dateTime: dateTime!,
            idNotification: notificationId));
    scheduleNotification('تذكير !', controller.text, _selectedDateTime);
    handleTapOutside();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    boardDateTimeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fraction = 0.25; // Adjust the fraction value as per your requirement
    double fontSizeWithResponsive = screenWidth * fraction * (fontsize / 100);
    return SafeArea(
      child: TapRegion(
        onTapOutside: (event) {
          handleTapOutside();
        },
        child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 5, right: 30),
            height: screenHeight * 0.22,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.04)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  cursorColor: Colors.amber,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: fontSizeWithResponsive,
                    height: screenHeight * 0.0015,
                  ),
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'ابدأ في الكتابة',
                      hintStyle: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal),
                      hintTextDirection: TextDirection.rtl),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        isWriteTask = true;
                      });
                    } else if (value.isEmpty) {
                      setState(() {
                        isWriteTask = false;
                      });
                    }
                  },
                  textDirection: currentTextDirection,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isSelcetedDateTime == false
                        ? TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0), // No padding
                              minimumSize: Size(0, 0), // Minimum size
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // Shrink wrap
                            ),
                            onPressed: () {
                              showDateTimePicker();
                            },
                            child: Text(
                              'set reminder',
                              style: TextStyle(color: Colors.blue),
                            ))
                        : Row(
                            children: [
                              Icon(Icons.alarm),
                              Text(' $dateTime | '),
                              IconButton(
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.all(0),
                                  style: const ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap, // the '2023' part
                                  ),
                                  onPressed: () {
                                    resetDatetime();
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                    (isWriteTask == true && isSelcetedDateTime == true)
                        ? TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.amber,
                              padding: EdgeInsets.all(0), // No padding
                              minimumSize: Size(0, 0), // Minimum size
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // Shrink wrap
                            ),
                            child: Text('Done'),
                            onPressed: () {
                              addTask();
                            },
                          )
                        : Text('Done')
                  ],
                )
              ],
            )),
      ),
    );
  }
}
