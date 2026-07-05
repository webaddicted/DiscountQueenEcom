import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/utils/app_utils.dart';

abstract class BaseService extends GetxService {
  bool _isInitialized = false;
  bool _isInitializing = false;
  Exception? _initException;

  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
  Exception? get initException => _initException;
  bool get hasInitError => _initException != null;

  @protected
  Future<void> onServiceInit() async {}
  @protected
  void onServiceClose() {}
  @protected
  void onInitError(Exception e) {
    printError('${runtimeType.toString()}', 'initialization failed: $e');
  }

  @override
  void onInit() { super.onInit(); _initialize(); }
  @override
  void onClose() { onServiceClose(); super.onClose(); }

  Future<void> _initialize() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;
    try {
      await onServiceInit();
      _isInitialized = true;
      _initException = null;
    } catch (e) {
      _initException = e is Exception ? e : Exception(e.toString());
      onInitError(_initException!);
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    if (!_isInitialized && _initException != null) throw _initException!;
  }

  Future<void> reinitialize() async {
    _isInitialized = false;
    _initException = null;
    await _initialize();
  }

  Future<T?> execute<T>({
    required Future<T> Function() action,
    Function(Exception)? onError,
  }) async {
    try {
      return await action();
    } catch (e) {
      onError?.call(e is Exception ? e : Exception(e.toString()));
      return null;
    }
  }

  void logDebug(String message) {
    if (kDebugMode) printLog('${runtimeType.toString()}', message);
  }

  void logError(String message, [Object? error]) {
    printError('${runtimeType.toString()}', '$message ${error ?? ''}');
  }
}

mixin PeriodicServiceMixin on BaseService {
  final List<_PeriodicTask> _periodicTasks = [];

  void startPeriodicTask(String taskId, Duration interval, Future<void> Function() task) {
    cancelPeriodicTask(taskId);
    final periodicTask = _PeriodicTask(id: taskId, interval: interval, task: task);
    _periodicTasks.add(periodicTask);
    periodicTask.start();
  }

  void cancelPeriodicTask(String taskId) {
    final index = _periodicTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _periodicTasks[index].cancel();
      _periodicTasks.removeAt(index);
    }
  }

  void cancelAllPeriodicTasks() {
    for (final task in _periodicTasks) { task.cancel(); }
    _periodicTasks.clear();
  }

  @override
  void onServiceClose() {
    cancelAllPeriodicTasks();
    super.onServiceClose();
  }
}

class _PeriodicTask {
  final String id;
  final Duration interval;
  final Future<void> Function() task;
  bool _isCancelled = false;

  _PeriodicTask({required this.id, required this.interval, required this.task});

  void start() { _runLoop(); }
  void cancel() { _isCancelled = true; }

  Future<void> _runLoop() async {
    while (!_isCancelled) {
      try { await task(); } catch (_) {}
      await Future.delayed(interval);
    }
  }
}
