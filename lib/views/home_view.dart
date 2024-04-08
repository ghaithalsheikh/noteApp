import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/hidden_button_cubit.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/views/add_note_view.dart';
import 'package:note_app/widgets/note_container.dart';
import 'package:note_app/widgets/right_to_left_nav.dart';
import 'package:note_app/widgets/searchbar_note_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.12,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Column(
            children: [
              Text(
                'ملاحظات',
                style: TextStyle(fontSize: fontSizeTitle),
              ),
              const SearchOfBarNote(),
            ],
          ),
        ),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteInitial) {
              return Container();
            } else if (state is NoteChangedState) {
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return NoteContainer(
                          title: state.homeList[index].title ?? '',
                          content: state.homeList[index].content ?? "",
                          dateTime: state.homeList[index].fixedDateTime,
                          noteModel: state.homeList[index],
                        );
                      },
                      childCount: state.homeList.length,
                    ),
                  ),
                ],
              );
            } else if (state is SearchNote) {
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return NoteContainer(
                          title: state.homeListSearch[index].title,
                          content: state.homeListSearch[index].content,
                          dateTime: state.homeListSearch[index].fixedDateTime,
                          noteModel: state.homeListSearch[index],
                        );
                      },
                      childCount: state.homeListSearch.length,
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: BlocBuilder<HiddenButtonCubit, HiddenButtonState>(
          builder: (context, state) {
            if (state is HiddenAddButtonState) {
              if (state.isHidden == true) {
                return Container();
              }
              if (state.isHidden == false) {
                return Container(
                  width: containerSizeOfAddNote,
                  height: containerSizeOfAddNote,
                  margin: EdgeInsets.only(
                      left: screenWidth * 0.05, bottom: screenHeight * 0.05),
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.9),
                    ),
                    backgroundColor: Colors.amber[600],
                    child: Icon(Icons.add,
                        color: Colors.black, size: iconSizeAddButton),
                    onPressed: () =>
                        Navigator.of(context).push(RightToLeftPageRoute(
                      builder: (context) => const NoteAddTextFeildView(),
                    )),
                  ),
                );
              }
            }
            return Container(
              width: containerSizeOfAddNote,
              height: containerSizeOfAddNote,
              margin: EdgeInsets.only(
                  left: screenWidth * 0.05, bottom: screenHeight * 0.05),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.9),
                ),
                backgroundColor: Colors.amber[500],
                child: Icon(Icons.add,
                    color: Colors.black, size: iconSizeAddButton),
                onPressed: () =>
                    Navigator.of(context).push(RightToLeftPageRoute(
                  builder: (context) => const NoteAddTextFeildView(),
                )),
              ),
            );
          },
        ),
      ),
    );
  }
}
