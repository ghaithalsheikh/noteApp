import 'dart:ui';

class NoteModel {
  final String? title;
  final String? content;
  final String fixedDateTime;
  final double? fontsize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  NoteModel({
    this.fontsize,
    this.fontWeight,
    this.fontStyle,
    required this.content,
    required this.title,
    required this.fixedDateTime,
  });
}
