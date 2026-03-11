import 'package:flutter/material.dart';

/// DesignOverlaySettings — Notifier for design overlay visualization states.
///
/// This manages the visibility of the Thumb Zone and Z-Pattern overlays
/// used for design optimization and ergonomic auditing.
class DesignOverlaySettings extends ChangeNotifier {
  bool _showThumbZone = false;
  bool _showZPattern = false;

  bool get showThumbZone => _showThumbZone;
  bool get showZPattern => _showZPattern;

  set showThumbZone(bool value) {
    if (_showThumbZone != value) {
      _showThumbZone = value;
      notifyListeners();
    }
  }

  set showZPattern(bool value) {
    if (_showZPattern != value) {
      _showZPattern = value;
      notifyListeners();
    }
  }

  void toggleThumbZone() {
    showThumbZone = !showThumbZone;
  }

  void toggleZPattern() {
    showZPattern = !showZPattern;
  }
}
