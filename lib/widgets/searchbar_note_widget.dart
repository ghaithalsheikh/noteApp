import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/note_cubite/hidden_button_cubit.dart';
import 'package:note_app/cubit/note_cubite/note_cubit.dart';

class SearchOfBarNote extends StatefulWidget {
  const SearchOfBarNote({
    super.key,
  });

  @override
  State<SearchOfBarNote> createState() => _SearchOfBarNoteState();
}

class _SearchOfBarNoteState extends State<SearchOfBarNote> {
  final TextEditingController _searchController = TextEditingController();
  final ui.TextDirection _currentTextDirection = TextDirection.rtl;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChanged);
  }

  void _handleFocusChanged() {
    if (focusNode.hasFocus) {
      BlocProvider.of<HiddenButtonCubit>(context).hiddenAddButton = true;
      BlocProvider.of<HiddenButtonCubit>(context).hiddenButton();
    }
    if (!focusNode.hasFocus) {
      BlocProvider.of<HiddenButtonCubit>(context).hiddenAddButton = false;
      BlocProvider.of<HiddenButtonCubit>(context).hiddenButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
      height: screenHeight * 0.05,
      child: TextField(
        focusNode: focusNode,
        cursorColor: Colors.amber,
        textInputAction: TextInputAction.done,
        autocorrect: true,
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          height: screenHeight * 0.0012,
        ),
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: focusNode.hasFocus
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    BlocProvider.of<NoteCubit>(context).getSearchtext(text: '');
                  },
                  icon: Icon(Icons.close))
              : SizedBox(),
          hintText: 'البحث عن ملاحظات',
          hintStyle: TextStyle(fontSize: screenWidth * 0.035),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          hintTextDirection: TextDirection.rtl,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(
                color: Theme.of(context).searchViewTheme.backgroundColor!),
          ),
        ),
        onSubmitted: (value) {
          setState(() {});
        },
        onChanged: (value) {
          BlocProvider.of<NoteCubit>(context).getSearchtext(text: value);
        },
        textDirection: _currentTextDirection,
      ),
    );
  }
}
