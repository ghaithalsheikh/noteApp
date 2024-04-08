import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/hidden_button_cubit.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/them.dart';
import 'package:note_app/views/home_view.dart';

void main() async {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NoteCubit>(
          create: (context) => NoteCubit(context),
        ),
        BlocProvider<HiddenButtonCubit>(
          create: (context) => HiddenButtonCubit(context),
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
      home: const HomeView(),
      theme: theme,
    );
  }
}
