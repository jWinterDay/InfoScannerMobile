import 'package:flutter/material.dart';
import 'package:info_scanner_mobile/blocs/logged_user_bloc.dart';
import 'package:info_scanner_mobile/models/logged_user_info.dart';

class LeftPanelScreen extends StatefulWidget {
  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanelScreen> {
  LoggedUserBloc bloc = new LoggedUserBloc();

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.getUserLocal();

    return Scaffold(
      appBar: AppBar(
        title:
        Row(children:
          <Widget>[
            Icon(Icons.settings),
            Text('Settings'),
          ],
        ),
      ),
      body:
        StreamBuilder(
          stream: bloc.loggedUserStream,
          builder: (context, AsyncSnapshot<LoggedUserInfo> snapshot) {
            LoggedUserInfo user = snapshot.data;

            if (snapshot.hasData) {
              return loggedUserMenu(context: context, bloc: bloc, user: user);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return notLoggedUserMenu(context: context, bloc: bloc, user: user);
          }
        )
    );
  }
}

Widget notLoggedUserMenu({@required BuildContext context, @required LoggedUserBloc bloc, @required LoggedUserInfo user}) {
  return
    Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Not logged', style: Theme.of(context).textTheme.title,),
          Row(children: <Widget>[
              FlatButton.icon(
                label: Text('Login'),
                icon: Icon(Icons.trending_up, color: Colors.blue),
                onPressed: () { Navigator.pushNamed(context, '/user_login'); },
              ),
            ],
          ),
        ],
      ),
    );
}

Widget loggedUserMenu({@required BuildContext context, @required LoggedUserBloc bloc, @required LoggedUserInfo user}) {
  return
    Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(user.email, style: Theme.of(context).textTheme.title,),
          Row(children: <Widget>[
              Text(user.fullName, style: Theme.of(context).textTheme.title,),
              FlatButton.icon(
                label: Text('Logout'),
                icon: Icon(Icons.exit_to_app, color: Colors.blue,),
                onPressed: bloc.removeUser(),
                //child: Icon(Icons.exit_to_app, color: Colors.blue,),
              ),
            ],
          ),
        ],
      ),
    );
}