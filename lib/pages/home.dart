import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/link_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> l = [];
  Future<void> _launchURL(String url) async {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      url = url;
    } else {
      url = 'https://$url';
    }
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    int folder_index = ModalRoute.of(context)!.settings.arguments as int;
    List<String> l =
        Provider.of<LinkList>(context).links[folder_index].folder_links;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Links'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<LinkList>(
          builder: (context, linkList, child) {
            return l.isEmpty
                ? const Center(
                    child: Text('NO LINKS!'),
                  )
                : ListView.builder(
                    itemCount: l.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          try {
                            _launchURL(l[index]);
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text(l[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                linkList.removelink(folder_index, index);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add a link'),
                  content: TextField(
                    decoration: const InputDecoration(
                      hintText: 'https://example.com',
                    ),
                    onSubmitted: (value) async {
                      await Provider.of<LinkList>(context, listen: false)
                          .addLink(folder_index, value)
                          .then((value) {
                        Navigator.of(context).pop();
                        setState(() {});
                      });
                    },
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
