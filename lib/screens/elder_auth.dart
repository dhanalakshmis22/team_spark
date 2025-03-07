import 'package:flutter/material.dart';
import 'elder_login.dart';
import 'elder_signup.dart';

class ElderAuthScreen extends StatefulWidget {
  @override
  _ElderAuthScreenState createState() => _ElderAuthScreenState();
}

class _ElderAuthScreenState extends State<ElderAuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elder Authentication')),
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
                ElderLoginScreen(),
                ElderSignUpScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
