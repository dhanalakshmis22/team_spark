import 'package:flutter/material.dart';
import '../database.dart';
import 'fall_detection.dart'; // ✅ Ensure this import is correct

class ElderLoginScreen extends StatefulWidget {
  @override
  _ElderLoginScreenState createState() => _ElderLoginScreenState();
}

class _ElderLoginScreenState extends State<ElderLoginScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final db = DatabaseHelper.instance;
    final elder = await db.elderLogin(_nameController.text, _passwordController.text);

    if (elder != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful!")));

      // ✅ Corrected the navigation to FallDetectionScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FallDetectionScreen(elderUniqueId: elder['unique_id'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Elder Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextFormField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
