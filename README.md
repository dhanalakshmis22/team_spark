# 🛡 Elderly Safety System

## 📌 Overview
The *Elderly Safety System* is an AI-powered mobile safety application designed to protect elderly individuals, particularly those with dementia, by providing real-time monitoring, emergency alerts, and caregiver pairing. This system ensures privacy, role-based authentication, and seamless communication between elders and caregivers.

## 🌟 Features
- *📉 Fall Detection*: Utilizes mobile sensors to detect falls and instantly alerts the assigned caregiver.
- *👥 Elder-Caregiver Pairing*: Prevents confusion by implementing a unique elder-caregiver assignment system.
- *📍 Geofencing & Wander Alerts*: Monitors elderly movements and notifies caregivers when an elder wanders beyond predefined safe zones.
- *🔐 Role-Based Authentication*: Separate sign-up/login flows for elders (aged 60+) and caregivers.
- *🚨 SOS Emergency Feature*: Provides an instant SOS button for immediate assistance.
- *🔒 Secure Communication*: Uses Firebase for reliable, encrypted, and real-time data exchange.
- *🌍 Open-Source & Self-Hosted*: Ensures data privacy and scalability.

## 🛠 Technology Stack
- *🖥 Frontend*: React Native (for cross-platform mobile support)
- *⚙ Backend*: Firebase (Authentication, Firestore, Cloud Messaging)
- *🤖 AI & Sensors*: Mobile-based accelerometer and gyroscope for fall detection
- *🗺 Geofencing*: Google Maps API for location tracking and alerts
- *🔑 Authentication*: Firebase Authentication with role-based access control

## ⚙ Installation & Setup
### 📋 Prerequisites
- Node.js & npm
- Firebase account
- React Native development environment

### 🚀 Steps
1. Clone the repository:
   sh
   git clone https://github.com/your-repo/elderly-safety-system.git
   cd elderly-safety-system
   
2. Install dependencies:
   sh
   npm install
   
3. Set up Firebase:
   - Create a Firebase project.
   - Enable Authentication, Firestore, and Cloud Messaging.
   - Download google-services.json (Android) or GoogleService-Info.plist (iOS) and place it in the respective folders.
4. Run the application:
   sh
   npx react-native run-android   # For Android
   npx react-native run-ios       # For iOS
   

## 📖 Usage
1. *👵 Elder Login*:
   - Sign up as an elder (Age 60+ verification required).
   - Pair with an
