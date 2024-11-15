import 'package:sm_app/components/drawer.dart';
import 'package:sm_app/components/round_button.dart';
import 'package:sm_app/utils/secure_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController tokenController = TextEditingController();
  SecureStorage secureStorage = SecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'token',
              labelText: 'token',
              prefixIcon: Icon(Icons.token_outlined),
            ),
            controller: tokenController,
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
            title: "Get ",
            onPress: () {
              secureStorage.readStorageData(tokenController.text);
            },
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
            title: "Remove ",
            onPress: () {
              secureStorage.removeStorageData(tokenController.text);
            },
          ),
        ],
      ),
    );
  }
}
