part of 'note_cubit.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteChangedState extends NoteState {
  final List<NoteModel> homeList;

  NoteChangedState({required this.homeList});
}

final class SearchNote extends NoteState {
  final List<NoteModel> homeListSearch;

  SearchNote({required this.homeListSearch});
}

final class IconActiveBold extends NoteState {
  final bool iconActivesBold;

  IconActiveBold({required this.iconActivesBold});
}

final class IconActiveItalic extends NoteState {
  final bool iconActiveItalics;

  IconActiveItalic({required this.iconActiveItalics});
}
