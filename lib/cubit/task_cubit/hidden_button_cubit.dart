import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'hidden_button_state.dart';

class HiddenButtonTaskCubit extends Cubit<HiddenButtonState> {
  HiddenButtonTaskCubit() : super(HiddenButtonInitial());
  bool hiddenAddButton = false;
  void hiddenButton() {
    if (hiddenAddButton == true) {
      emit(HiddenButtonTask(isHidden: hiddenAddButton));
    } else if (hiddenAddButton == false) {
      emit(HiddenButtonTask(isHidden: hiddenAddButton));
    }
  }
}
