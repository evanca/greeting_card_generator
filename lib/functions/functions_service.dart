import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final FirebaseFunctions _firebaseFunctions;

  FunctionsService({FirebaseFunctions? firebaseFunctions})
      : _firebaseFunctions = firebaseFunctions ?? FirebaseFunctions.instance;

  Future<String?> helloGemini() async {
    try {
      final callable = _firebaseFunctions.httpsCallable('helloGeminiFunction');
      final result = await callable.call();

      final response = result.data;
      log('\n🤖Response: $response\n', name: 'FunctionsService');
      return response.toString();
    } catch (error, __) {
      log('❌ Error: $error', name: 'FunctionsService');
    }
    return null;
  }
}
