part of 'hidden_button_cubit.dart';

@immutable
sealed class HiddenButtonState {}

final class HiddenButtonInitial extends HiddenButtonState {}

final class HiddenAddButtonState extends HiddenButtonState {
  final bool isHidden;

  HiddenAddButtonState({required this.isHidden});
}
