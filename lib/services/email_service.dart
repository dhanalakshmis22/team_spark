import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {
  static Future<void> sendFallAlert(String caregiverEmail, String elderName) async {
    final Email email = Email(
      body: "⚠️ ALERT: $elderName has fallen and hasn't responded within 10 seconds. Please check on them immediately.",
      subject: "Emergency Fall Alert 🚨",
      recipients: [caregiverEmail],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      print("📧 Alert sent to caregiver!");
    } catch (error) {
      print("❌ Failed to send email: $error");
    }
  }
}
