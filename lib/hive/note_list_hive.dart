import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:note_app/models/note_model.dart';

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = 0;

  @override
  NoteModel read(BinaryReader reader) {
    return NoteModel(
      title: reader.readString(),
      content: reader.readString(),
      fixedDateTime: reader.readString(),
      fontsize: _readNullableDouble(reader),
      fontWeight: _readNullableFontWeight(reader),
      fontStyle: _readNullableFontStyle(reader),
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer.writeString(obj.title ?? '');
    writer.writeString(obj.content ?? '');
    writer.writeString(obj.fixedDateTime);
    writer.writeDouble(obj.fontsize ?? 0.0);
    writer.writeInt(obj.fontWeight?.index ?? 0);
    writer.writeInt(obj.fontStyle?.index ?? 0);
  }

  double? _readNullableDouble(BinaryReader reader) {
    try {
      return reader.readDouble();
    } catch (e) {
      return null;
    }
  }

  FontWeight? _readNullableFontWeight(BinaryReader reader) {
    try {
      return FontWeight.values[reader.readInt()];
    } catch (e) {
      return null;
    }
  }

  FontStyle? _readNullableFontStyle(BinaryReader reader) {
    try {
      return FontStyle.values[reader.readInt()];
    } catch (e) {
      return null;
    }
  }
}
