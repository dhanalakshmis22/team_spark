import 'package:flutter/material.dart';
import '../database.dart';

class ElderSignUpScreen extends StatefulWidget {
  @override
  _ElderSignUpScreenState createState() => _ElderSignUpScreenState();
}

class _ElderSignUpScreenState extends State<ElderSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  String? _generatedId;

  Future<void> _registerElder() async {
    if (_formKey.currentState!.validate()) {
      final age = int.parse(_ageController.text);
      if (age < 60) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Age must be 60 or above.")));
        return;
      }

      final db = DatabaseHelper.instance;

      // Generate unique ID based on current timestamp
      String uniqueId = "E" + DateTime.now().millisecondsSinceEpoch.toString();

      int result = await db.registerElder(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          age,
          uniqueId
      );

      if (result > 0) {
        setState(() {
          _generatedId = uniqueId; // Store the generated ID
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Elder registered successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration failed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Elder Sign-Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter Name" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Enter Email" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) => value!.isEmpty ? "Enter Password" : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter Age" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _registerElder, child: Text("Register")),
              if (_generatedId != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Your Unique ID: $_generatedId",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
