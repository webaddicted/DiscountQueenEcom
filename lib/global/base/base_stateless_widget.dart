import 'package:flutter/material.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  const BaseStatelessWidget({super.key});

  Widget initBuild(BuildContext context);

  @override
  Widget build(BuildContext context) => initBuild(context);

  Size screenSize(BuildContext c) => MediaQuery.of(c).size;
  double screenWidth(BuildContext c) => screenSize(c).width;
  double screenHeight(BuildContext c) => screenSize(c).height;
  bool isDarkMode(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
  ThemeData theme(BuildContext c) => Theme.of(c);
  TextTheme textTheme(BuildContext c) => Theme.of(c).textTheme;
  ColorScheme colorScheme(BuildContext c) => theme(c).colorScheme;
  EdgeInsets safePadding(BuildContext c) => MediaQuery.of(c).padding;
  EdgeInsets viewInsets(BuildContext c) => MediaQuery.of(c).viewInsets;
  bool isKeyboardVisible(BuildContext c) => MediaQuery.of(c).viewInsets.bottom > 0;
  void hideKeyboard(BuildContext c) => FocusScope.of(c).unfocus();
}
