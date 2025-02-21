import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greeting_card_generator_sandbox/ui/theme.dart';

import 'app/auth_service.dart';
import 'input_page/input_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = await Firebase.initializeApp(
    // TODO: Run 'flutterfire configure' and uncomment the following line:
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  await AuthService(app: app).signInAnonymously();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI-Powered Greetings',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeOf(context),
      home: const InputPage(),
    );
  }
}
