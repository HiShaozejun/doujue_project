import 'base_notifier.dart';

class EmptyNotifier extends BaseNotifier {
  EmptyNotifier(super.context);

  @override
  void init() {}

  @override
  void onCleared() {}
}
