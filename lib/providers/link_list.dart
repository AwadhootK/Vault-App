import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Folder {
  String name = '';
  Color folder_col;
  List<String> folder_links;
  Folder(this.name, this.folder_col, this.folder_links);
}

class LinkList with ChangeNotifier {
  List<Folder> _links = [];
  late final db;

  LinkList(this.db);
  List<Folder> get links => _links;

  bool get isEmpty => _links.isEmpty;

  Future<void> clear() async {
    _links.clear();
    final db = await openDatabase('folders_database.db');
    await db.delete('folders');
    await db.close();
  }

  Future<void> getFolders() async {
    WidgetsFlutterBinding.ensureInitialized();
    final db = await openDatabase('folders_database.db');
    List<Map<String, dynamic>> map_folders = await db.query('folders');
    _links = map_folders.map(
      (e) {
        Folder f = Folder(
          e['name'],
          Color(e['folder_col']),
          e['folder_links'].split(','),
        );
        return f;
      },
    ).toList();
    print(_links);
    notifyListeners();
  }

  Future<void> storeFolders() async {
    final db = await openDatabase('folders_database.db');
    db.delete('folders');
    for (final folder in _links) {
      await db
          .insert(
            'folders',
            {
              'name': folder.name,
              'folder_col': folder.folder_col.value,
              'folder_links': folder.folder_links.join(','),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
          .then((value) => print('done'));
    }
    await db.close();
    getFolders();
  }

  Future<void> addLink(int folder_index, String link) async {
    _links[folder_index].folder_links.insert(0, link);
    await storeFolders();
    notifyListeners();
  }

  Future<void> addFolder(String name, Color c) async {
    _links.add(Folder(name, c, []));
    await storeFolders();
    notifyListeners();
  }

  Future<void> removeFolder(int index) async {
    _links.removeAt(index);
    notifyListeners();
  }

  Future<void> removelink(int folder_index, int link_index) async {
    _links[folder_index].folder_links.removeAt(link_index);
    await storeFolders();
    notifyListeners();
  }
}
