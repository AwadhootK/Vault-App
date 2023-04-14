import 'package:flutter/material.dart';
import 'package:lock_app/pages/auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

import './providers/lock.dart';
import './pages/home.dart';
import './providers/link_list.dart';
import './pages/folderscreen.dart';

late final db;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await openDatabase(
    join(await getDatabasesPath(), 'folders_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE folders(id INTEGER PRIMARY KEY, name TEXT, folder_col INTEGER, folder_links TEXT)',
      );
    },
    version: 1,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LinkList(db)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FingerPrintAuth(),
        routes: {
          HomePage.routeName: (context) => HomePage(),
          FolderScreen.routeName: (context) => FolderScreen(),
        },
      ),
    );
  }
}
