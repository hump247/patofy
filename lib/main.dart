import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:patofy/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await _requestPermissions();


  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  if (await Permission.storage.request().isGranted) {
    print('Storage permission granted');
  } else {
    print('Storage permission not granted');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

