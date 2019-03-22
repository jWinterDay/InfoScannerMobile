import 'package:flutter/material.dart';

class UserRegisterScreen extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            //Icon(Icons.supervised_user_circle),
            Text('Register'),
          ],
        )
      ),
      body: Text('Register')
    );
  }
}