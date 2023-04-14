import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lock_app/pages/folderscreen.dart';

class FingerPrintAuth extends StatefulWidget {
  const FingerPrintAuth({super.key});

  @override
  State<FingerPrintAuth> createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {
  late final LocalAuthentication _localAuthentication;
  bool _canCheckBiometrics = false;
  bool authenticated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localAuthentication = LocalAuthentication();
    _localAuthentication.isDeviceSupported().then((isSupported) {
      setState(() {
        _canCheckBiometrics = isSupported;
      });
    });
  }

  Future<void> getAvailableBiometrics() async {
    print(';called');
    List<BiometricType> biometrics =
        await _localAuthentication.getAvailableBiometrics();
    print(biometrics);
    if (!mounted) {
      return;
    }
  }

  Future<bool> _authenticate() async {
    try {
      return await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access your folders',
        options: AuthenticationOptions(stickyAuth: false, biometricOnly: true),
      );
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FingerPrint Auth')),
      body: !_canCheckBiometrics
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: _authenticate(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.of(context)
                          .pushReplacementNamed(FolderScreen.routeName);
                    });
                  } else {
                    return Column(
                      children: [
                        const Center(
                          child: Text('Authentication Failed'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _authenticate();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }
}
