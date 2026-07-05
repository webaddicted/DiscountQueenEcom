import 'dart:async';

import 'package:flutter/material.dart';

mixin ResourceManagerMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];
  final List<AnimationController> _animationControllers = [];
  final List<TextEditingController> _textControllers = [];
  final List<ScrollController> _scrollControllers = [];
  final List<TabController> _tabControllers = [];
  final List<PageController> _pageControllers = [];
  final List<FocusNode> _focusNodes = [];

  void addSubscription(StreamSubscription sub) => _subscriptions.add(sub);
  void addTimer(Timer timer) => _timers.add(timer);
  void addAnimationController(AnimationController c) => _animationControllers.add(c);
  void addTextController(TextEditingController c) => _textControllers.add(c);
  void addScrollController(ScrollController c) => _scrollControllers.add(c);
  void addTabController(TabController c) => _tabControllers.add(c);
  void addPageController(PageController c) => _pageControllers.add(c);
  void addFocusNode(FocusNode node) => _focusNodes.add(node);

  TextEditingController createTextController([String? text]) {
    final c = TextEditingController(text: text);
    _textControllers.add(c);
    return c;
  }

  ScrollController createScrollController({double initialOffset = 0}) {
    final c = ScrollController(initialScrollOffset: initialOffset);
    _scrollControllers.add(c);
    return c;
  }

  PageController createPageController({int initialPage = 0}) {
    final c = PageController(initialPage: initialPage);
    _pageControllers.add(c);
    return c;
  }

  FocusNode createFocusNode() {
    final n = FocusNode();
    _focusNodes.add(n);
    return n;
  }

  Timer createTimer(Duration duration, VoidCallback callback) {
    final t = Timer(duration, callback);
    _timers.add(t);
    return t;
  }

  Timer createPeriodicTimer(Duration period, void Function(Timer) callback) {
    final t = Timer.periodic(period, callback);
    _timers.add(t);
    return t;
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  void executeAfterBuild(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  @override
  void dispose() {
    for (final s in _subscriptions) { s.cancel(); }
    for (final t in _timers) { t.cancel(); }
    for (final a in _animationControllers) { a.dispose(); }
    for (final t in _textControllers) { t.dispose(); }
    for (final s in _scrollControllers) { s.dispose(); }
    for (final t in _tabControllers) { t.dispose(); }
    for (final p in _pageControllers) { p.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }
}

abstract class Disposable {
  void dispose();
}

class DisposableWrapper implements Disposable {
  final VoidCallback _disposeCallback;
  DisposableWrapper(this._disposeCallback);

  @override
  void dispose() => _disposeCallback();
}
