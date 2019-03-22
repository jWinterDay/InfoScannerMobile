import 'package:flutter/material.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLoginScreen> {
  static final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final _emailController = TextEditingController(text: null);
  final _passwordController = TextEditingController(text: null);

  String _emailValidator(val) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(val) ? null : 'Wrong EMail format';
  }

  _onLogin() {
    final form = formKey.currentState;
    if (form.validate()) {
      print('valid form');
      String email = _emailController.text;
      String password = _passwordController.text;

      //Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Login'),
          ],
        )
      ),

      body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    //email
                    TextFormField(
                      controller: _emailController,
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'EMail'
                      ),
                      validator: _emailValidator,
                      autovalidate: true,
                      keyboardType: TextInputType.emailAddress
                    ),
                    //password
                    TextFormField(
                      controller: _passwordController,
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Password'
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: RaisedButton(
                  child: Icon(Icons.access_alarm),
                  onPressed: _onLogin,
                ),
              ),
            ],
          ),
        ),
    );
  }
}