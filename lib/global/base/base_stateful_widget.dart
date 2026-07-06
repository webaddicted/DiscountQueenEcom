import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/theme/text_style.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseState<T extends BaseStatefulWidget> extends State<T> {
  Widget initBuild(BuildContext context);

  @protected
  void initUIState() {}
  @protected
  void onDispose() {}
  @protected
  void onFirstFrame() {}
  @protected
  void onDependenciesChange() {}
  @protected
  void onWidgetUpdate(T oldWidget) {}

  @override
  void initState() {
    super.initState();
    initUIState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) onFirstFrame();
    });
  }

  @override
  void dispose() { onDispose(); super.dispose(); }

  @override
  void didChangeDependencies() { super.didChangeDependencies(); onDependenciesChange(); }

  @override
  void didUpdateWidget(covariant T oldWidget) { super.didUpdateWidget(oldWidget); onWidgetUpdate(oldWidget); }

  @override
  Widget build(BuildContext context) => initBuild(context);

  void safeSetState(VoidCallback fn) { if (mounted) setState(fn); }

  Size get screenSize => MediaQuery.of(context).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  ThemeData get theme => Theme.of(context);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  EdgeInsets get safePadding => MediaQuery.of(context).padding;
  EdgeInsets get viewInsets => MediaQuery.of(context).viewInsets;
  bool get isKeyboardVisible => viewInsets.bottom > 0;
  void hideKeyboard() => FocusScope.of(context).unfocus();

  void showLoading({String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Material(color: Colors.transparent, child: Text(message, style: AppTextStyle.bodyMedium.copyWith(color: Colors.white))),
            ],
          ]),
        ),
      ),
    );
  }

  void hideLoading() { if (Navigator.canPop(context)) Navigator.pop(context); }

  void navigateTo(String route, {dynamic arguments}) => Get.toNamed(route, arguments: arguments);
  Future<R?> navigateToScreen<R>(Widget screen) => Navigator.push<R>(context, MaterialPageRoute(builder: (_) => screen));
  Future<R?> navigateReplace<R>(Widget screen) => Navigator.pushReplacement<R, dynamic>(context, MaterialPageRoute(builder: (_) => screen));
  void pop<R>([R? result]) => Navigator.pop<R>(context, result);

  Future<void> delayedExecution(Duration duration, VoidCallback callback) async {
    await Future.delayed(duration);
    if (mounted) callback();
  }
}
