import 'dart:typed_data';

import 'package:flutter/material.dart';

class GreetingController extends ChangeNotifier {
  GreetingController._();
  static final GreetingController instance = GreetingController._();

  String? _greetingText;
  Uint8List? _greetingImage;

  String? _error;

  String? get greetingText => _greetingText;

  void setGreetingText(String text) {
    _greetingText = text;
    notifyListeners();
  }

  Uint8List? get greetingImage => _greetingImage;

  void setGreetingImage(Uint8List? image) {
    _greetingImage = image;
    notifyListeners();
  }

  String? get error => _error;

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  get isLoading => (_greetingText == null || _greetingImage == null) && _error == null;
}