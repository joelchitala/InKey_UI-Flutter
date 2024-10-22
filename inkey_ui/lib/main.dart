import 'package:flutter/material.dart';
import 'package:inkey_flutter_v1/inkey_flutter_v1.dart';
import 'package:inkey_ui/src/features/crud_operations/key_value_screen.dart';

// Future<void> setUp() async {
//   InKeyDB inKeyDB = InKeyDB();

//   await inKeyDB.setUpFromFile(filePath: "./inkey_database.json");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    InKeyDbCommitStatefulWidget(
      filePath: "./inkey_database.json",
      commitStates: const [],
      inKeyDB: InKeyDB(),
      body: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: KeyValueScreen(),
      ),
    );
  }
}
