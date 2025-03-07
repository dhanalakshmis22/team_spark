import 'package:flutter/material.dart';
import 'package:fall_detection_app/screens/elder_auth.dart';
import 'package:fall_detection_app/screens/caregiver_auth.dart';

void main() {
  runApp(FallDetectionApp());
}

class FallDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fall Detection App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserSelectionScreen(),
    );
  }
}

class UserSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fall Detection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElderAuthScreen())),
              child: Text('Elder Authentication'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CaregiverAuthScreen())),
              child: Text('Caregiver Authentication'),
            ),
          ],
        ),
      ),
    );
  }
}
