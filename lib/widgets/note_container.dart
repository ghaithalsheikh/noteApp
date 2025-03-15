import 'package:flutter/material.dart';
import 'package:note_app/models/note_model.dart';

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
    double myContainerHeight = screenHeight * 0.135;
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.007),
        height: myContainerHeight,
        width: double.infinity,
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
