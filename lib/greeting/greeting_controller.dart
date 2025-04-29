import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:greeting_card_generator_sandbox/functions/functions_service.dart';
import 'package:greeting_card_generator_sandbox/input_page/models/form_input.dart';

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

  Future<void> generateGreeting(FormInput formInput, String errorText) async {
    setError(null);
    final output = await FunctionsService().generateGreetingText(formInput);
    if (output != null) {
      setGreetingText(output);
    } else {
      setError(errorText);
    }

    final image = await FunctionsService().generateImage(formInput);
    if (image != null) {
      setGreetingImage(image);
    } else {
      setError(errorText);
    }
  }
}