import 'package:hive/hive.dart';
import 'package:note_app/models/task_model.dart';

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel(
        title: reader.readString(),
        dateTime: reader.readString(),
        idNotification: readNullableInt(reader));
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.dateTime);
    writer.writeInt32(obj.idNotification);
  }

  int readNullableInt(BinaryReader reader) {
    try {
      return reader.readInt();
    } catch (e) {
      return 0;
    }
  }
}
