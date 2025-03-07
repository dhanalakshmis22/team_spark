import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../database.dart';
import '../services/email_service.dart';

// 🚀 Fall Detection Service
class FallDetectionService {
  final double fallThreshold = 6.0;
  final int detectionTimeFrame = 10000;
  StreamSubscription? _accelerometerSubscription;
  bool isFalling = false;

  void startMonitoring(Function onFallDetected, String elderUniqueId) {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double acceleration = _calculateAcceleration(event);

      if (acceleration < fallThreshold && !isFalling) {
        isFalling = true;
        print("⚠️ Possible Fall Detected! Checking...");

        Future.delayed(Duration(seconds: 10), () async {
          if (isFalling) {
            print("🚨 Fall Confirmed! Sending Alert...");
            final db = DatabaseHelper.instance;
            final caregiver = await db.getCaregiverByElderId(elderUniqueId);

            if (caregiver != null) {
              await EmailService.sendFallAlert(caregiver['email'], "An Elder has fallen!");
            }
          }
        });

        onFallDetected();
      }
    });
  }

  double _calculateAcceleration(AccelerometerEvent event) {
    return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  }

  void stopMonitoring() {
    _accelerometerSubscription?.cancel();
  }
}

// 🚀 Elder Login Screen
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FallDetectionScreen(elder['unique_id'])),
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

// 🚀 Fall Detection Screen
class FallDetectionScreen extends StatefulWidget {
  final String elderUniqueId;
  FallDetectionScreen(this.elderUniqueId);

  @override
  _FallDetectionScreenState createState() => _FallDetectionScreenState();
}

class _FallDetectionScreenState extends State<FallDetectionScreen> {
  final FallDetectionService _fallDetectionService = FallDetectionService();
  bool _fallDetected = false;

  @override
  void initState() {
    super.initState();
    _fallDetectionService.startMonitoring(() {
      setState(() {
        _fallDetected = true;
      });

      // Wait 10 seconds before sending alert
      Timer(Duration(seconds: 10), () {
        if (_fallDetected) {
          _sendAlert();
        }
      });
    }, widget.elderUniqueId);
  }

  void _sendAlert() async {
    final db = DatabaseHelper.instance;
    final caregiver = await db.getCaregiverByElderId(widget.elderUniqueId);

    if (caregiver != null) {
      await EmailService.sendFallAlert(caregiver['email'], "An Elder has fallen!");
    }
  }

  void _cancelAlert() {
    setState(() {
      _fallDetected = false;
    });
  }

  @override
  void dispose() {
    _fallDetectionService.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fall Detection")),
      body: Center(
        child: _fallDetected
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Fall Detected! 🚨", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cancelAlert,
              child: Text("I'm Okay"),
            ),
          ],
        )
            : Text("Monitoring..."),
      ),
    );
  }
}

// 🚀 Email Service for Alerting Caregiver
class EmailService {
  static Future<void> sendFallAlert(String caregiverEmail, String elderName) async {
    print("Sending email to $caregiverEmail: $elderName has fallen!");
  }
}
