import 'package:djqs/base/extensions/function_extensions.dart';
import 'package:flutter/material.dart';

extension AnimationExtensions on Animation {
  void addCompletedCallback(Function callback) {
    void handler(status) {
      if (status == AnimationStatus.completed) {
        removeStatusListener(handler);
        callback();
      }
    }

    addStatusListener(handler);
  }

  void addStatusCallback(
      {Function? onForward,
      Function? onReverse,
      Function? onDismissed,
      Function? onCompleted}) {
    void handler(status) {
      switch (status) {
        case AnimationStatus.forward:
          onForward?.checkNullInvoke();
          break;
        case AnimationStatus.reverse:
          onReverse?.checkNullInvoke();
          break;
        case AnimationStatus.dismissed:
          removeStatusListener(handler);
          onDismissed?.checkNullInvoke();
          break;
        case AnimationStatus.completed:
          removeStatusListener(handler);
          onCompleted?.checkNullInvoke();
          break;
      }
    }

    addStatusListener(handler);
  }
}
