import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/views/changed_note_view.dart';
import 'package:note_app/widgets/right_to_left_nav.dart';

class NoteContainer extends StatelessWidget {
  const NoteContainer({
    super.key,
    this.title,
    this.content,
    this.noteModel,
    required this.dateTime,
  });
  final String? title;
  final String? content;
  final String dateTime;
  final NoteModel? noteModel;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double myContainerWidth = screenWidth * 0.5;
    double myContainerHeight = screenHeight * 0.135;
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                'هل تريد حذف هذه الملاحظة ؟',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'لا',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'نعم',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  onPressed: () {
                    BlocProvider.of<NoteCubit>(context)
                        .removeItem(noteModel: noteModel!);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      onTap: () => Navigator.of(context).push(RightToLeftPageRoute(
        builder: (context) => NoteChangeTextFeildView(
          title: title ?? '',
          content: content ?? '',
          dateTime: dateTime,
          noteModel: noteModel!,
        ),
      )),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenHeight * 0.007),
        height: myContainerHeight,
        width: myContainerWidth,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(screenWidth * 0.04)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title!.isEmpty ? content! : title!,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: screenWidth * 0.035, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              textDirection: TextDirection.rtl,
              title!.isEmpty || content!.isEmpty ? "لا يوجد نص" : content!,
              style:
                  TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              dateTime,
              style:
                  TextStyle(fontSize: screenWidth * 0.025, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
