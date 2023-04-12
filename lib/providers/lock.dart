import 'package:flutter/material.dart';
import './../pages/home.dart';
import '../pages/folderscreen.dart';

class Lock extends StatelessWidget {
  const Lock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lock App',
          ),
          centerTitle: true,
          leading: const Icon(Icons.lock),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter Password'),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                keyboardType: TextInputType.visiblePassword,
                onSubmitted: (value) {
                  if (value == '3817') {
                    Navigator.of(context)
                        .pushReplacementNamed(FolderScreen.routeName);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Wrong Password'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
              ),
            ],
          ),
        ));
  }
}
