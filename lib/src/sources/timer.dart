import 'dart:async';
import 'package:flutter/material.dart';

abstract class ITimer {
  void start(Duration delay, VoidCallback callback);
  void cancel();
}

class BatchTimer extends ITimer {
  Timer? sub;

  @override
  void start(Duration delay, VoidCallback callback) =>
      sub = Timer(delay, callback);
  @override
  void cancel() => sub?.cancel();
}

class TestFriendlyTimer extends ITimer {
  @override
  void cancel() {}
  @override
  void start(Duration delay, VoidCallback callback) => callback();
}
