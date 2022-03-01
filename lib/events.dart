import "package:flutter/widgets.dart";
import "package:mobile_labs/location.dart";

class LocationSelectedAction extends Action<MyIntent> {
  LocationSelectedAction(this.point);

  final LocationPoint? point;

  @override
  void addActionListener(ActionListenerCallback listener) {
    super.addActionListener(listener);
    debugPrint("Action Listener was added");
  }

  @override
  void removeActionListener(ActionListenerCallback listener) {
    super.removeActionListener(listener);
    debugPrint("Action Listener was removed");
  }

  @override
  void invoke(covariant MyIntent intent) {
    notifyActionListeners();
  }
}

class MyIntent extends Intent {
  const MyIntent();
}