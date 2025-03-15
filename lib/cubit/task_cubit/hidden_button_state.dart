part of 'hidden_button_cubit.dart';

@immutable
sealed class HiddenButtonState {}

final class HiddenButtonInitial extends HiddenButtonState {}

final class HiddenButtonTask extends HiddenButtonState {
  final bool isHidden;

  HiddenButtonTask({required this.isHidden});
}
