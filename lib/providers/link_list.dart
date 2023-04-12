import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Folder {
  String name = '';
  Color folder_col;
  List<String> folder_links = [];
  Folder(this.name, this.folder_col);
}

class LinkList with ChangeNotifier {
  List<Folder> _links = [];
  late final db;

  List<Folder> get links => _links;
  LinkList(this.db);

  Future<void> getFolders() async {
    notifyListeners();
  }

  Future<void> storeFolders() async {
    // for (final folder in _links) {
    //   await db.insert(
    //     'folders',
    //     {
    //       'name': folder.name,
    //       'folder_col': folder.folder_col.value,
    //       'folder_links': folder.folder_links.join(','),
    //     },
    //     conflictAlgorithm: ConflictAlgorithm.replace,
    //   );
    // }
    // await db.close();
  }

  Future<void> addLink(int folder_index, String link) async {
    _links[folder_index].folder_links.insert(0, link);
    // await storeFolders();
    notifyListeners();
  }

  Future<void> addFolder(String name, Color c) async {
    _links.add(Folder(name, c));
    // await storeFolders();
    notifyListeners();
  }

  Future<void> removeFolder(int index) async {
    _links.removeAt(index);
    // await storeFolders();
    notifyListeners();
  }

  Future<void> removelink(int folder_index, int link_index) async {
    _links[folder_index].folder_links.removeAt(link_index);
    // await storeFolders();
    notifyListeners();
  }
}
