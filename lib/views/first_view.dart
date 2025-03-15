import 'package:flutter/material.dart';
import 'package:note_app/views/home_view.dart';
import 'package:note_app/views/task_view.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            labelColor: Colors.amber,
            labelPadding: EdgeInsets.symmetric(horizontal: 40),
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.center,
            dividerColor: Colors.transparent,
            isScrollable: true,
            automaticIndicatorColorAdjustment: false,
            tabs: [
              Tab(
                icon: Icon(Icons.edit_note),
              ),
              Tab(
                icon: Icon(
                  Icons.task,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [HomeView(), TaskView()]),
      ),
    );
  }
}
