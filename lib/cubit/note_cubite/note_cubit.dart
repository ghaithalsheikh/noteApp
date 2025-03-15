import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:note_app/hive/note_list_hive.dart';
import 'package:note_app/models/note_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  Box<dynamic>? box;
  NoteCubit(BuildContext context) : super(NoteInitial()) {
    initialize();
  }
  bool iconActivesBold = false;
  bool iconActivesItalic = false;

  void iconActivesFontBold() {
    if (iconActivesBold == true) {
      emit(IconActiveBold(iconActivesBold: iconActivesBold));
    }
  }

  void iconActivesFontItalic() {
    if (iconActivesItalic == true) {
      emit(IconActiveItalic(iconActiveItalics: iconActivesItalic));
    }
  }

  Future<void> initialize() async {
    await openHiveBox(); // Open the Hive box
    getHomeList(); // Retrieve homeList from the Hive box
  }

  void gethomelistincasenotfoundvalue() {
    getHomeList();
  }

  Future<void> openHiveBox() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteModelAdapter()); // Register the type adapter
    box = await Hive.openBox<dynamic>('notes'); // Await the openBox method
  }

  void addItem({required NoteModel noteModel}) async {
    await box?.add(noteModel);

    getHomeList();
  }

  void removeItem({required List<NoteModel> listNoteModel}) async {
    for (var item in listNoteModel) {
      for (var i = 0; i < box!.length; i++) {
        NoteModel value = box!.getAt(i);

        if (value.title == item.title && value.content == item.content) {
          await box!.deleteAt(i);
        }
      }
    }
    getHomeList();
  }

  void getHomeList() async {
    if (box != null) {
      List<NoteModel> homeListe = [];
      for (var i = 0; i < box!.length; i++) {
        NoteModel value = box!.getAt(i);

        homeListe.insert(0, value);
      }
      emit(NoteChangedState(homeList: homeListe));
    }
  }

  void getSearchtext({required String text}) async {
    List<NoteModel> homeListeSearch = [];
    if (text.isEmpty) {
      getHomeList();
    } else if (text.isNotEmpty) {
      for (int i = 0; i < box!.length; i++) {
        NoteModel value = box!.getAt(i);

        if (value.content!.contains(text) || value.title!.contains(text)) {
          homeListeSearch.insert(0, value);
        }
      }
      emit(SearchNote(homeListSearch: homeListeSearch));
    }
  }
}
