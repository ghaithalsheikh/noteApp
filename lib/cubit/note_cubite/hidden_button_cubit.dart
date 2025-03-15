import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'hidden_button_state.dart';

class HiddenButtonCubit extends Cubit<HiddenButtonState> {
  HiddenButtonCubit(BuildContext context) : super(HiddenButtonInitial());

  bool hiddenAddButton = false;
  void hiddenButton() {
    if (hiddenAddButton == true) {
      emit(HiddenAddButtonState(isHidden: hiddenAddButton));
    } else if (hiddenAddButton == false) {
      emit(HiddenAddButtonState(isHidden: hiddenAddButton));
    }
  }
}
