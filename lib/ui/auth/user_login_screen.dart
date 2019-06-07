import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:info_scanner_mobile/actions/auth_actions.dart';
import 'package:info_scanner_mobile/blocs/auth_bloc.dart';
import 'package:info_scanner_mobile/models/auth/auth_model.dart';
import 'package:info_scanner_mobile/models/redux/app_state.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/ui/components/footer_common_info.dart';


typedef OnUserLoginCallback = Function();

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLoginScreen> {
  final AuthBloc _bloc = new AuthBloc();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      bottomNavigationBar: footerCommonInfo(isNavigator: false),
      //persistentFooterButtons: <Widget>[
      //  footerCommonInfo(isNavigator: false),
      //],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: StreamBuilder(
              stream: _bloc.resultStream,
              builder: (context, AsyncSnapshot<LoggedUserInfo> snapshot) {
                return Column(
                  children: <Widget>[
                    _formFields(context, snapshot),
                    _submitBtn(context, snapshot),
                    _loginResult(context, snapshot),
                  ],
                );
              }
            )
          )
        )
      )
    );
  }

  Widget _formFields(BuildContext context, AsyncSnapshot<LoggedUserInfo> snapshot) {
    bool isLoading = snapshot.hasData && snapshot.data.isLoading;
    bool isEnabled = !isLoading;

    var captionStyle = TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //email
          Align(
            alignment: Alignment.topLeft,
            child: Text('EMail', style: captionStyle),
          ),
          TextFormField(
            enabled: isEnabled,
            maxLength: 30,
            focusNode: _emailNode,
            controller: _bloc.emailController,
            style: Theme.of(context).textTheme.headline,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              hintStyle: TextStyle(fontStyle: FontStyle.italic),
              hintText: 'Use your site name'
            ),
            validator: _bloc.emailValidator,
            autovalidate: true,
            //autofocus: true,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (email) {
              //FocusScope.of(context).requestFocus(_passwordNode);
            }
          ),
          //password
          Align(
            alignment: Alignment.topLeft,
            child: Text('Password', style: captionStyle),
          ),
          TextFormField(
            enabled: isEnabled,
            focusNode: _passwordNode,
            maxLength: 20,
            controller: _bloc.passwordController,
            style: Theme.of(context).textTheme.headline,
            decoration: InputDecoration(
              icon: Icon(Icons.security),
              hintStyle: TextStyle(fontStyle: FontStyle.italic),
              hintText: 'Your password'
            ),
            obscureText: true,
            autovalidate: true,
            textInputAction: TextInputAction.go,
            validator: _bloc.passwordValidator,
            onFieldSubmitted: (psw) {
              //onLogin();
            },
          ),
        ],
      ),
    );
  }

  Widget _submitBtn(BuildContext context, AsyncSnapshot<LoggedUserInfo> snapshot) {
    bool isLoading = snapshot.hasData && snapshot.data.isLoading;
    var color = isLoading ? Colors.red : Colors.green;

    return Align(
      alignment: Alignment.topLeft,
        child: FlatButton.icon(
          label: Text('Login', style: TextStyle(fontSize: 16),),
          icon: Icon(Icons.play_circle_outline, color: color),
          onPressed: isLoading ? null : _bloc.login
        )
    );
  }

  Widget _loginResult(BuildContext context, AsyncSnapshot<LoggedUserInfo> snapshot) {
    if (snapshot.hasData) {
      LoggedUserInfo userInfo = snapshot.data;
      bool isLoading = userInfo.isLoading;

      if (isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (userInfo.error != null) {
        return Text(userInfo.error.toString(), style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w800));
      }

      String infoStr = 'Logged as ${userInfo.firstName}, ${userInfo.lastName}';

      return Text(infoStr, style: TextStyle(color: Colors.lightGreen, fontSize: 20, fontWeight: FontWeight.w800));
    } else if (snapshot.hasError) {
      return Text(snapshot.error.toString());
    }

    return Container();
  }
}

/*class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController(text: 'jwinterday@mail.ru');
final TextEditingController _passwordController = TextEditingController(text: '123');
FocusNode passwordNode = FocusNode();

typedef OnLoginCallback = void Function();




String _emailValidator(val) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return (val != null && regex.hasMatch(val)) ? null : 'Wrong EMail format';
  }
String _passwordValidator(val) {
  String psw = val as String;
  return (psw == null || psw.trim().length < 3) ? 'Enter minimum 3 non empty symbols' : null;
}


class _UserLoginState extends State<UserLoginScreen> {
  final GlobalInfoBloc bloc = new GlobalInfoBloc();

  _onLogin() {
    final form = formKey.currentState;
    if (!form.validate()) {
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    bloc.login(email, password);
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.getInitial();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Login'),
          ],
        )
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: ListView(
          children: <Widget>[
            _loginForm(context, onLogin: _onLogin),
            StreamBuilder(
              stream: bloc.loggedUserStream,
              builder: (context, AsyncSnapshot<LoggedUserInfo> snapshot) {
                //print('builder snapshot data: ${snapshot.data}');

                if (snapshot.hasData) {
                  LoggedUserInfo user = snapshot.data;

                  if (user.isLoading) {
                    return Row(
                      children: <Widget>[
                        _submitBtn(context, onLogin: null),
                        CircularProgressIndicator()
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        _submitBtn(context, onLogin: _onLogin),
                        Text(
                          'Welcome, ${user.firstName}, ${user.lastName}',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800, fontSize: 20),
                        )
                      ],
                    );
                    
                  }
                } else if (snapshot.hasError) {
                  return Column(
                    children: <Widget>[
                      _submitBtn(context, onLogin: _onLogin),
                      Text(snapshot.error.toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800, ),),
                    ],
                  );
                }

                return _submitBtn(context, onLogin: _onLogin);
              }
            )
          ],
        )
      )
    );
  }
}

Widget _loginForm(BuildContext context, {@required OnLoginCallback onLogin}) {
  return Form(
    key: formKey,
    child: Column(
      children: <Widget>[
        //email
        Align(
          alignment: Alignment.topLeft,
          child: Text('EMail', style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextFormField(
          maxLength: 30,
          controller: _emailController,
          style: Theme.of(context).textTheme.headline,
          decoration: InputDecoration(
            icon: Icon(Icons.email),
            hintStyle: TextStyle(fontStyle: FontStyle.italic),
            hintText: 'Use your site name'
          ),
          validator: _emailValidator,
          autovalidate: true,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          onFieldSubmitted: (email) {
            FocusScope.of(context).requestFocus(passwordNode);
          },
        ),
        //password
        Align(
          alignment: Alignment.topLeft,
          child: Text('Password', style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextFormField(
          focusNode: passwordNode,
          maxLength: 20,
          controller: _passwordController,
          style: Theme.of(context).textTheme.headline,
          decoration: InputDecoration(
            icon: Icon(Icons.security),
            hintStyle: TextStyle(fontStyle: FontStyle.italic),
            hintText: 'Your password'
          ),
          obscureText: true,
          autovalidate: true,
          textInputAction: TextInputAction.go,
          validator: _passwordValidator,
          onFieldSubmitted: (psw) {
            onLogin();
          },
        ),
      ],
    ),
  );
}

Widget _submitBtn(BuildContext context, {@required OnLoginCallback onLogin}) {
  return
    Align(
      alignment: Alignment.topLeft,
      child:
        RaisedButton(
          child: Icon(Icons.play_circle_outline),
          onPressed: onLogin
        ),
    );
}*/