// lib/screens/caregiver_signup.dart
import 'package:flutter/material.dart';
import '../database.dart';

class CaregiverSignUpScreen extends StatefulWidget {
  @override
  _CaregiverSignUpScreenState createState() => _CaregiverSignUpScreenState();
}

class _CaregiverSignUpScreenState extends State<CaregiverSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _elderIdController = TextEditingController();

  Future<void> _registerCaregiver() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseHelper.instance;

      // Check if Elder's Unique ID exists
      final elder = await db.getElderByUniqueId(_elderIdController.text);
      if (elder == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Elder Unique ID!")));
        return;
      }

      // Register Caregiver
      int result = await db.registerCaregiver(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _elderIdController.text,
      );

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Caregiver Registered Successfully!")));
        Navigator.pop(context); // Go back to login page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Failed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Caregiver Sign-Up")),
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
                controller: _elderIdController,
                decoration: InputDecoration(labelText: "Elder Unique ID"),
                validator: (value) => value!.isEmpty ? "Enter Elder's Unique ID" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _registerCaregiver, child: Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
