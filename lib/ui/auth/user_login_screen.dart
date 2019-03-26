import 'package:flutter/material.dart';
import 'package:info_scanner_mobile/models/logged_user_info.dart';
import 'package:info_scanner_mobile/blocs/logged_user_bloc.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController(text: 'jwinterday@mail.ru');
final TextEditingController _passwordController = TextEditingController(text: 'R%5rty');
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
  final LoggedUserBloc bloc = new LoggedUserBloc();

  //constructor
  _UserLoginState() {
    
  }

  _onLogin() {
    final form = formKey.currentState;
    if (!form.validate()) {
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    /*var tt = Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) =>
        RedeemConfirmationScreen()
      )
    );*/

    //Navigator.of(context).push(TutorialOverlay());

    bloc.login(email, password);
      //Navigator.pop(context);
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
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            _loginForm(context, onLogin: _onLogin),
            StreamBuilder(
              stream: bloc.loggedUserStream,
              builder: (context, AsyncSnapshot<LoggedUserInfo> snapshot) {
                print('builder snapshot data: ${snapshot.data}');

                if (snapshot.hasData) {
                  LoggedUserInfo user = snapshot.data;

                  if (user.inFetchState) {
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
                          'Welcome, ${user.fullName}',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800, fontSize: 20),
                        )
                      ],
                    );
                    
                  }
                } else if (snapshot.hasError) {
                  return Column(
                    children: <Widget>[
                      _submitBtn(context, onLogin: _onLogin),
                      Text(snapshot.error.toString()),
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
}

/////////////
/*class TutorialOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'This is a nice overlay',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Dismiss'),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}*/

/*class RedeemConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.85),
      body: Center(
        child: RaisedButton(
          child: Text('close'),//Center(child: CircularProgressIndicator()),//  Text('close'),
          onPressed: () => Navigator.pop(context)
        ),
      )
    );
  }
}*/


/*void showDialogSingleButton(BuildContext context, String title, String message, String buttonLabel) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(buttonLabel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}*/