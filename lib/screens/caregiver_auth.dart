import 'package:flutter/material.dart';
import 'caregiver_login.dart';
import 'caregiver_signup.dart';

class CaregiverAuthScreen extends StatefulWidget {
  @override
  _CaregiverAuthScreenState createState() => _CaregiverAuthScreenState();
}

class _CaregiverAuthScreenState extends State<CaregiverAuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Caregiver Authentication')),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Sign Up'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CaregiverLoginScreen(),
                CaregiverSignUpScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
