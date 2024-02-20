import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_da2/pages/logOutPage.dart';
import 'package:map_da2/pages/map.dart';
import 'package:map_da2/pages/myhomepages.dart';
import 'package:map_da2/pages/settingPage.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => MyHomePages());
    case '/home':
      return MaterialPageRoute(builder: (context) => MyHomePage());
    case '/settings':
      return MaterialPageRoute(builder: (context) => SettingsPage());
    case '/logout':
      return MaterialPageRoute(builder: (context) => LogoutPage());
    default:
      return MaterialPageRoute(builder: (context) => MyHomePage());
  }
      },
    );
  }
}

