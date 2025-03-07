import 'dart:async'; // ✅ Import Timer here
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../database.dart';
import '../services/email_service.dart';

class FallDetectionScreen extends StatefulWidget {
  final String elderUniqueId; // Elder's unique ID to track caregiver

  FallDetectionScreen({required this.elderUniqueId});

  @override
  _FallDetectionScreenState createState() => _FallDetectionScreenState();
}

class _FallDetectionScreenState extends State<FallDetectionScreen> {
  final double fallThreshold = 6.0;
  bool isFalling = false;
  Timer? _fallTimer;

  @override
  void initState() {
    super.initState();
    _startFallMonitoring();
  }

  void _startFallMonitoring() {
    accelerometerEvents.listen((event) {
      double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (acceleration < fallThreshold && !isFalling) {
        setState(() {
          isFalling = true;
        });
        print("⚠️ Possible Fall Detected! Waiting for response...");

        _fallTimer = Timer(Duration(seconds: 10), () async {
          if (isFalling) {
            print("🚨 No response detected. Sending alert...");
            _sendFallAlert();
          }
        });

        _showFallAlertDialog();
      }
    });
  }

  Future<void> _sendFallAlert() async {
    final db = DatabaseHelper.instance;
    final elder = await db.getElderByUniqueId(widget.elderUniqueId);
    final caregiver = await db.getCaregiverByElderId(widget.elderUniqueId);

    if (caregiver != null) {
      await EmailService.sendFallAlert(caregiver['email'], elder!['name']);
      print("📧 Alert sent to caregiver: ${caregiver['email']}");
    } else {
      print("⚠️ No caregiver linked to this elder.");
    }
  }

  void _showFallAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Fall Detected!"),
        content: Text("Do you need help?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isFalling = false;
              });
              _fallTimer?.cancel();
            },
            child: Text("I'm Okay"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fallTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fall Detection")),
      body: Center(
        child: Text(
          isFalling ? "🚨 Fall Detected! Checking..." : "No Fall Detected",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
