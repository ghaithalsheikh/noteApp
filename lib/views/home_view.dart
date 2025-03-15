import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/note_cubite/hidden_button_cubit.dart';
import 'package:note_app/cubit/note_cubite/note_cubit.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/views/add_note_view.dart';
import 'package:note_app/views/changed_note_view.dart';
import 'package:note_app/widgets/note_container.dart';
import 'package:note_app/widgets/right_to_left_nav.dart';
import 'package:note_app/widgets/searchbar_note_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSelectionMode = false;
  Set<int> selectedItemsNote = <int>{};
  bool isHiddenAddButton = false;
  bool hiddenOnTap = false;
  List<NoteModel> listNoteModel = [];

  _selectAll({required List countOfItem}) {
    if (selectedItemsNote.length == countOfItem.length) {
      selectedItemsNote.clear();
    } else {
      selectedItemsNote.addAll(List.generate(countOfItem.length, (i) => i));
    }
    isSelectionMode = selectedItemsNote.isNotEmpty;
  }

  void _toggleSelection(int index, {required NoteModel noteModel}) {
    setState(() {
      if (selectedItemsNote.contains(index)) {
        selectedItemsNote.remove(index);
      } else {
        listNoteModel.add(noteModel);
        selectedItemsNote.add(index);
      }
      isSelectionMode = selectedItemsNote.isNotEmpty;
    });
  }

  _deleteSelected({required List<NoteModel> listTaskmodel}) {
    BlocProvider.of<NoteCubit>(context)
        .removeItem(listNoteModel: listTaskmodel);

    setState(() {
      selectedItemsNote.clear();
      isSelectionMode = false;
    });
  }

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
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteInitial) {
              return Container();
            } else if (state is NoteChangedState) {
              return CustomScrollView(
                slivers: [
                  isSelectionMode
                      ? SliverAppBar(
                          centerTitle: true,
                          title: Text('${selectedItemsNote.length} مختارة'),
                          leading: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                hiddenOnTap = false;
                                selectedItemsNote.clear();
                                isSelectionMode = false;
                                isHiddenAddButton = false;
                              });
                            },
                          ),
                          actions: [
                            IconButton(
                              icon: selectedItemsNote.length ==
                                      state.homeList.length
                                  ? Icon(
                                      Icons.checklist_rtl_sharp,
                                      color: Colors.amber,
                                    )
                                  : Icon(
                                      Icons.checklist_rtl_sharp,
                                    ),
                              onPressed: () {
                                _selectAll(countOfItem: state.homeList);
                                isHiddenAddButton = false;
                                setState(() {});
                              },
                            ),
                          ],
                        )
                      : SliverAppBar(
                          toolbarHeight: screenHeight * 0.12,
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            hiddenOnTap = true;
                            if (!isSelectionMode) {
                              setState(() => isSelectionMode = true);
                            }
                            isHiddenAddButton = true;
                            _toggleSelection(index,
                                noteModel: NoteModel(
                                  title: state.homeList[index].title ?? '',
                                  content: state.homeList[index].content ?? "",
                                  fixedDateTime:
                                      state.homeList[index].fixedDateTime,
                                ));
                          },
                          onTap: () {
                            if (hiddenOnTap) {
                              if (selectedItemsNote.isEmpty) {
                                isHiddenAddButton = false;
                              }
                              if (isSelectionMode) {
                                _toggleSelection(index,
                                    noteModel: NoteModel(
                                      title: state.homeList[index].title ?? '',
                                      content:
                                          state.homeList[index].content ?? "",
                                      fixedDateTime:
                                          state.homeList[index].fixedDateTime,
                                    ));
                              }
                            } else {
                              Navigator.of(context).push(RightToLeftPageRoute(
                                builder: (context) => NoteChangeTextFeildView(
                                  title: state.homeList[index].title ?? '',
                                  content: state.homeList[index].content ?? "",
                                  dateTime: state.homeList[index].fixedDateTime,
                                  noteModel: state.homeList[index],
                                ),
                              ));
                            }
                          },
                          child: Stack(
                            children: [
                              NoteContainer(
                                title: state.homeList[index].title ?? '',
                                content: state.homeList[index].content ?? "",
                                dateTime: state.homeList[index].fixedDateTime,
                                noteModel: state.homeList[index],
                              ),
                              if (isSelectionMode)
                                Positioned(
                                  right: 20,
                                  top: 25,
                                  child: Checkbox(
                                    shape: CircleBorder(),
                                    checkColor: Colors.white,
                                    activeColor: Colors.amber,
                                    value: selectedItemsNote.contains(index),
                                    onChanged: (_) => _toggleSelection(index,
                                        noteModel: NoteModel(
                                          title:
                                              state.homeList[index].title ?? '',
                                          content:
                                              state.homeList[index].content ??
                                                  "",
                                          fixedDateTime: state
                                              .homeList[index].fixedDateTime,
                                        )),
                                  ),
                                )
                              else
                                SizedBox(),
                            ],
                          ),
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
                  SliverAppBar(
                    toolbarHeight: screenHeight * 0.12,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(RightToLeftPageRoute(
                              builder: (context) => NoteChangeTextFeildView(
                                title: state.homeListSearch[index].title ?? '',
                                content:
                                    state.homeListSearch[index].content ?? "",
                                dateTime:
                                    state.homeListSearch[index].fixedDateTime,
                                noteModel: state.homeListSearch[index],
                              ),
                            ));
                          },
                          child: NoteContainer(
                            title: state.homeListSearch[index].title,
                            content: state.homeListSearch[index].content,
                            dateTime: state.homeListSearch[index].fixedDateTime,
                            noteModel: state.homeListSearch[index],
                          ),
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
        bottomNavigationBar: isSelectionMode
            ? BottomAppBar(
                child: Column(
                  children: [
                    IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(0),
                      style: const ButtonStyle(
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // the '2023' part
                      ),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 32,
                      ),
                      onPressed: () {
                        _deleteSelected(listTaskmodel: listNoteModel);
                      },
                      color: Colors.white,
                    ),
                    Text('حذف')
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
