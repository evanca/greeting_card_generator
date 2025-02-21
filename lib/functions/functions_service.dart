import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:greeting_card_generator_sandbox/input_page/models/form_input.dart';

class FunctionsService {
  final FirebaseFunctions _firebaseFunctions;

  FunctionsService({FirebaseFunctions? firebaseFunctions})
      : _firebaseFunctions = firebaseFunctions ?? FirebaseFunctions.instance;

  Future<String?> generateGreetingText(FormInput input) async {
    try {
      final callable =
          _firebaseFunctions.httpsCallable('generateGreetingTextFunction');
      final result = await callable.call(input.toJson());

      final response = result.data;
      log('\n🤖 Response: $response\n', name: 'FunctionsService');
      return response.toString();
    } catch (error, __) {
      log('❌ Error: $error', name: 'FunctionsService');
    }
    return null;
  }

  Future<Uint8List?> generateImage(FormInput input) async {
    try {
      final callable =
          _firebaseFunctions.httpsCallable('generateGreetingImageFunction');
      final result = await callable.call(input.toJson());

      final response = result.data;

      final url = response['url'] as String;
      final bytes = base64.decode(url.split(',').last);

      return (bytes);
    } catch (error, __) {
      log('❌ Error: $error', name: 'FunctionsService');
    }
    return null;
  }
}
