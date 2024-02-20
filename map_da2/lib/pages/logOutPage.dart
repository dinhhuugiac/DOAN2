import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Đóng ứng dụng
            SystemNavigator.pop();
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
