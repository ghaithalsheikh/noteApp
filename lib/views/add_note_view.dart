import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:note_app/cubit/note_cubite/note_cubit.dart';
import 'package:note_app/models/note_model.dart';

class NoteAddTextFeildView extends StatefulWidget {
  const NoteAddTextFeildView({
    super.key,
    this.title,
    this.content,
  });
  final String? title;
  final String? content;

  @override
  State<NoteAddTextFeildView> createState() => _NoteAddTextFeildViewState();
}

class _NoteAddTextFeildViewState extends State<NoteAddTextFeildView> {
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controller = TextEditingController();

  bool isTextFieldActive = false;
  TextDirection _currentTextDirection = TextDirection.rtl;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  String? title;
  String? content;
  String dateTimeCurrent =
      intl.DateFormat('yyyy-MM-dd HH-mm').format(DateTime.now());
  double _fontsize = 16;

  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _fontStyle = FontStyle.normal;
  double id = 0;
  bool focusSumbitedText = false;

  @override
  void initState() {
    super.initState();
    controllerTitle.text = widget.title ?? '';
    controller.text = widget.content ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    controllerTitle.dispose();
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _performAction();
    super.deactivate();
  }

  void _performAction() {
    if (title != null || content != null) {
      BlocProvider.of<NoteCubit>(context).addItem(
        noteModel: NoteModel(
          content: content ?? '',
          title: title ?? '',
          fixedDateTime: intl.DateFormat('yyyy-MM-dd HH-mm').format(
            DateTime.now(),
          ),
          fontsize: _fontsize,
          fontStyle: _fontStyle,
          fontWeight: _fontWeight,
        ),
      );
    }
    if (title == null && content == null) {
      BlocProvider.of<NoteCubit>(context).gethomelistincasenotfoundvalue();
    }
  }

  TextDirection _getTextDirection(String value) {
    if (value.isEmpty) {
      return TextDirection.rtl; // Default direction
    } else if (value.contains(RegExp(r'[\u0600-\u06FF]'))) {
      // Arabic characters detected
      if (value.contains(RegExp(r'[a-zA-Z]'))) {
        // Both Arabic and English characters are present
        final firstChar = value.codeUnitAt(0);
        if ((firstChar >= 65 && firstChar <= 90) ||
            (firstChar >= 97 && firstChar <= 122)) {
          // First character is an English character
          return TextDirection.ltr;
        }
      }
      return TextDirection
          .rtl; // Only Arabic characters or Arabic + non-English characters
    } else {
      return TextDirection.ltr; // Non-Arabic characters
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fraction = 0.25; // Adjust the fraction value as per your requirement
    double fontSizeWithResponsive = screenWidth * fraction * (_fontsize / 100);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              focusSumbitedText = true;
              if (focusSumbitedText == true) {
                _focusNode.unfocus();
                focusSumbitedText = false;
              } else {
                FocusScope.of(context).requestFocus(_focusNode);
              }
            },
            icon: Icon(
              Icons.check_rounded,
              size: screenWidth * 0.1,
            )),
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.keyboard_arrow_right,
                size: screenWidth * 0.1,
              )),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: KeyboardActions(
        config: KeyboardActionsConfig(
            keyboardBarColor: Theme.of(context).dividerColor,
            nextFocus: false,
            actions: [
              KeyboardActionsItem(
                  focusNode: _focusNode,
                  toolbarAlignment: MainAxisAlignment.start,
                  toolbarButtons: [
                    (node) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.001,
                            bottom: screenHeight * 0.001,
                            left: screenWidth * 0.07),
                        child: GestureDetector(
                          onTap: () {
                            if (_fontsize < 22) {
                              _fontsize = _fontsize + 2;
                            }
                            setState(() {});
                          },
                          child: Icon(
                            Icons.text_increase,
                            color: Theme.of(context).iconTheme.color,
                            size: screenWidth * 0.07,
                          ),
                        ),
                      );
                    },
                    (node) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.001,
                            bottom: screenHeight * 0.001,
                            left: screenWidth * 0.07),
                        child: GestureDetector(
                          onTap: () {
                            if (_fontsize > 16) {
                              _fontsize = _fontsize - 2;
                            }
                            setState(() {});
                          },
                          child: Icon(
                            Icons.text_decrease,
                            color: Theme.of(context).iconTheme.color,
                            size: screenWidth * 0.07,
                          ),
                        ),
                      );
                    },
                    (node) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.001,
                            bottom: screenHeight * 0.001,
                            left: screenWidth * 0.07),
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<NoteCubit>(context)
                                .iconActivesBold = true;
                            BlocProvider.of<NoteCubit>(context)
                                .iconActivesFontBold();
                            setState(() {
                              if (_fontWeight == FontWeight.normal) {
                                _fontWeight = FontWeight.bold;
                              } else {
                                _fontWeight = FontWeight.normal;
                              }
                            });
                            BlocProvider.of<NoteCubit>(context)
                                .iconActivesBold = false;
                          },
                          child: BlocBuilder<NoteCubit, NoteState>(
                            builder: (context, state) {
                              if (state is IconActiveBold) {
                                if (state.iconActivesBold == true &&
                                    _fontWeight == FontWeight.bold) {
                                  return Icon(
                                    Icons.format_bold,
                                    color: Colors.amber,
                                    size: screenWidth * 0.07,
                                  );
                                } else if (state.iconActivesBold == true &&
                                    _fontWeight == FontWeight.normal) {
                                  return Icon(
                                    Icons.format_bold,
                                    color: Theme.of(context).iconTheme.color,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveItalic) {
                                if (state.iconActiveItalics == true &&
                                    _fontStyle == FontStyle.italic &&
                                    _fontWeight == FontWeight.bold) {
                                  return Icon(
                                    Icons.format_bold,
                                    color: Colors.amber,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveItalic) {
                                if (state.iconActiveItalics == true &&
                                    _fontStyle == FontStyle.italic &&
                                    _fontWeight == FontWeight.normal) {
                                  return Icon(
                                    Icons.format_bold,
                                    color: Theme.of(context).iconTheme.color,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveItalic) {
                                if (state.iconActiveItalics == true &&
                                    _fontStyle == FontStyle.normal &&
                                    _fontWeight == FontWeight.bold) {
                                  return Icon(
                                    Icons.format_bold,
                                    color: Colors.amber,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveItalic) {
                                if (state.iconActiveItalics == true &&
                                    _fontStyle == FontStyle.normal &&
                                    _fontWeight == FontWeight.normal) {
                                  return Icon(
                                    Icons.format_bold,
                                    color: Theme.of(context).iconTheme.color,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              return Icon(
                                Icons.format_bold,
                                color: Theme.of(context).iconTheme.color,
                                size: screenWidth * 0.07,
                              );
                            },
                          ),
                        ),
                      );
                    },
                    (node) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.001,
                            bottom: screenHeight * 0.001,
                            left: screenWidth * 0.07),
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<NoteCubit>(context)
                                .iconActivesItalic = true;
                            BlocProvider.of<NoteCubit>(context)
                                .iconActivesFontItalic();
                            setState(() {
                              if (_fontStyle == FontStyle.normal) {
                                _fontStyle = FontStyle.italic;
                              } else {
                                _fontStyle = FontStyle.normal;
                              }
                            });
                            BlocProvider.of<NoteCubit>(context)
                                .iconActivesItalic = false;
                          },
                          child: BlocBuilder<NoteCubit, NoteState>(
                            builder: (context, state) {
                              if (state is IconActiveItalic) {
                                if (state.iconActiveItalics == true &&
                                    _fontStyle == FontStyle.italic) {
                                  return Icon(
                                    Icons.format_italic,
                                    color: Colors.amber,
                                    size: screenWidth * 0.07,
                                  );
                                } else if (state.iconActiveItalics == true &&
                                    _fontStyle == FontStyle.normal) {
                                  return Icon(
                                    Icons.format_italic,
                                    color: Theme.of(context).iconTheme.color,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveBold) {
                                if (state.iconActivesBold == true &&
                                    _fontWeight == FontWeight.bold &&
                                    _fontStyle == FontStyle.italic) {
                                  return Icon(
                                    Icons.format_italic,
                                    color: Colors.amber,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveBold) {
                                if (state.iconActivesBold == true &&
                                    _fontWeight == FontWeight.bold &&
                                    _fontStyle == FontStyle.normal) {
                                  return Icon(
                                    Icons.format_italic,
                                    color: Theme.of(context).iconTheme.color,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveBold) {
                                if (state.iconActivesBold == true &&
                                    _fontWeight == FontWeight.normal &&
                                    _fontStyle == FontStyle.normal) {
                                  return Icon(
                                    Icons.format_italic,
                                    color: Theme.of(context).iconTheme.color,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              if (state is IconActiveBold) {
                                if (state.iconActivesBold == true &&
                                    _fontWeight == FontWeight.normal &&
                                    _fontStyle == FontStyle.italic) {
                                  return Icon(
                                    Icons.format_italic,
                                    color: Colors.amber,
                                    size: screenWidth * 0.07,
                                  );
                                }
                              }
                              return Icon(
                                Icons.format_italic,
                                color: Theme.of(context).iconTheme.color,
                                size: screenWidth * 0.07,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ])
            ]),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  cursorColor: Colors.amber,
                  focusNode: _focusNode2,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  autocorrect: true,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    height: screenHeight * 0.0015,
                  ),
                  controller: controllerTitle,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'العنوان',
                      hintStyle: TextStyle(fontSize: screenWidth * 0.05),
                      hintTextDirection: TextDirection.rtl),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                    } else if (value.isEmpty) {}
                  },
                  onChanged: (value) {
                    title = value;
                    setState(() {
                      isTextFieldActive = value.isNotEmpty;
                      _currentTextDirection = _getTextDirection(value);
                    });
                    if (value.isEmpty) {
                      setState(() {
                        isTextFieldActive = false;
                      });
                    }
                  },
                  textDirection: _currentTextDirection,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      " ${controller.text.length} حرف",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: screenWidth * 0.024),
                    ),
                    Text(
                      '|',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    Text(
                      dateTimeCurrent,
                      style: TextStyle(fontSize: screenWidth * 0.024),
                    ),
                  ],
                ),
                TextField(
                  cursorColor: Colors.amber,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: 50000,
                  autofocus: true,
                  style: TextStyle(
                      fontSize: fontSizeWithResponsive,
                      height: screenHeight * 0.0015,
                      fontWeight: _fontWeight,
                      fontStyle: _fontStyle),
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'ابدأ في الكتابة',
                      hintStyle: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal),
                      hintTextDirection: TextDirection.rtl),
                  onChanged: (value) {
                    content = value;
                    setState(() {
                      isTextFieldActive = value.isNotEmpty;
                      _currentTextDirection = _getTextDirection(value);
                    });
                    if (value.isEmpty) {
                      setState(() {
                        isTextFieldActive = false;
                      });
                    }
                  },
                  textDirection: _currentTextDirection,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
