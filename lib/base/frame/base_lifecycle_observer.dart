import 'package:flutter/widgets.dart';

class BaseLifecycleObserver with WidgetsBindingObserver {
  static final ValueNotifier<bool> _isInForeground = ValueNotifier(true);

  final ValueNotifier<AppLifecycleState> lifecycleState =
      ValueNotifier(AppLifecycleState.resumed);

  static final BaseLifecycleObserver _instance =
      BaseLifecycleObserver._internal();

  factory BaseLifecycleObserver() => _instance;

  BaseLifecycleObserver._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  static bool get isAppInForeground => _isInForeground.value;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground.value = (state == AppLifecycleState.resumed);
    lifecycleState.value = state;
  }
}
