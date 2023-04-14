import 'package:flutter/material.dart';
import 'package:lock_app/providers/link_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import './home.dart';

class FolderScreen extends StatefulWidget {
  static const routeName = '/folder-screen';
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  bool _isloading = false;
  List<Folder> l = [];
  late final provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<LinkList>(context, listen: false);
    _loadData();
  }

  void _loadData() async {
    await provider.getFolders();
    l = provider.links;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: const Text('Your Folders'),
        actions: [
          IconButton(
            onPressed: () async =>
                await Provider.of<LinkList>(context, listen: false)
                    .clear()
                    .then((value) => setState(() {
                          _loadData();
                        })),
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Provider.of<LinkList>(context, listen: false).links.isEmpty
              ? const Center(
                  child: Text('NO FOLDERS!'),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(HomePage.routeName, arguments: index);
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Folder?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Provider.of<LinkList>(context,
                                            listen: false)
                                        .removeFolder(index)
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    });
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                          color: l[index].folder_col.withOpacity(0.7),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                              height: 200,
                              width: 200,
                              child: Center(
                                child: Text(l[index].name),
                              ))),
                    ),
                    itemCount: l.length,
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Color c = Colors.white;
          String name = "";
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Enter Name of Folder'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text('Choose Color'),
                      const SizedBox(
                        height: 30,
                      ),
                      ColorPicker(
                        pickerColor: Colors.blue,
                        onColorChanged: (value) {
                          c = value;
                        },
                        pickerAreaHeightPercent: 0.8,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (c != Colors.white && name != "") {
                              await Provider.of<LinkList>(context,
                                      listen: false)
                                  .addFolder(name, c)
                                  .then((value) {
                                Navigator.of(context).pop();
                                setState(() {
                                  _loadData();
                                });
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                        title: Text('Enter Name and Color!!',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ));
                            }
                          },
                          child: const Text('DONE'))
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
