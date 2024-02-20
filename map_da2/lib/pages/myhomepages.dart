import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_da2/customs/customheader.dart';
import 'package:map_da2/infomation.dart';
class MyHomePages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DINH HUU GIAC 20119069 '),
      ),
      body: InFoMation() ,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple[200],
              ),
              child: CustomHeader(),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('MAP'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('LogOuts'),
              onTap: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
