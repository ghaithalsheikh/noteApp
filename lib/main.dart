import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/task_completed_cubit/task_copmeted_cubit.dart';
import 'package:note_app/cubit/note_cubite/hidden_button_cubit.dart';
import 'package:note_app/cubit/note_cubite/note_cubit.dart';
import 'package:note_app/cubit/task_cubit/hidden_button_cubit.dart';
import 'package:note_app/cubit/task_cubit/task_cubit.dart';
import 'package:note_app/them.dart';
import 'package:note_app/views/first_view.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NoteCubit>(
          create: (context) => NoteCubit(context),
        ),
        BlocProvider<HiddenButtonCubit>(
          create: (context) => HiddenButtonCubit(context),
        ),
        BlocProvider<HiddenButtonTaskCubit>(
          create: (context) => HiddenButtonTaskCubit(),
        ),
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(),
        ),
        BlocProvider<TaskCopmetedCubit>(
          create: (context) => TaskCopmetedCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  ); // Run the application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? darkMode
            : brightnessMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstView(),
      theme: theme,
    );
  }
}
