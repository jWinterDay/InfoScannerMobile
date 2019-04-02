import 'package:flutter/material.dart';

import 'package:info_scanner_mobile/blocs/sync_bloc.dart';
import 'package:info_scanner_mobile/blocs/logged_user_bloc.dart';

import 'package:info_scanner_mobile/models/logged_user_info.dart';
import 'package:info_scanner_mobile/models/sync_model.dart';
import 'package:info_scanner_mobile/resources/Exceptions.dart';

//LoggedUserBloc userBloc = new LoggedUserBloc();//object in logged_user_bloc.dart
SyncBloc syncBloc = new SyncBloc();

class LeftPanelScreen extends StatefulWidget {
  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanelScreen> {
  @override
  void dispose() {
    super.dispose();

    //userBloc.dispose();
    syncBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    gUserBloc.getUserLocal();

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
          stream: gUserBloc.loggedUserStream,
          builder: (context, AsyncSnapshot<LoggedUserInfo> snapshot) {
            LoggedUserInfo user = snapshot.data;

            if (snapshot.hasData) {
              return loggedUserMenu(context: context, user: user);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return notLoggedUserMenu(context: context);
          }
        )
    );
  }
}

Widget notLoggedUserMenu({@required BuildContext context}) {
  return
    Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Not logged', style: Theme.of(context).textTheme.title,),
          Padding(padding: EdgeInsets.only(bottom: 50)),
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

Widget loggedUserMenu({@required BuildContext context, @required LoggedUserInfo user}) {
  syncBloc.getInitial();

  return
    Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(user.email??'unknown email', style: Theme.of(context).textTheme.title, ),
          Text(user.fullName??'unnamed user', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.blue)),
          Padding(padding: EdgeInsets.only(bottom: 50)),
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                  label: Text('Logout'),
                  icon: Icon(Icons.exit_to_app, color: Colors.blue,),
                  onPressed: () { gUserBloc.removeUser(); },
                ),
              ),
              StreamBuilder(
                stream: syncBloc.syncStream,
                builder: (context, AsyncSnapshot<SyncModel> snapshot) {
                  return syncInfo(context: context, snapshot: snapshot);
                }
              )
            ],
          ),
        ],
      ),
    );
}

onSyncCallback() {
  if (syncBloc != null) {
    syncBloc.syncAll();
  }
}

Widget syncInfo({@required BuildContext context, @required AsyncSnapshot<SyncModel> snapshot}) {
  SyncModel syncModel = snapshot.data;

  if (snapshot.hasData) {
    if (syncModel.inFetchState) {
      return syncHasDataInProcess(context, syncModel);
    }
    return syncHasDataNotInProcess(context, syncModel);
  } else if (snapshot.hasError) {
    //print('err==============${snapshot.error}');
    //auth exception
    if (snapshot.error is AuthException) {
      return Column(
        children: <Widget>[
          //Navigator.pushNamed(context, '/login');
          Text(snapshot.error.toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800, ),),
          FlatButton.icon(
            icon: Icon(Icons.trending_up),
            label: Text('press here for relogin', style: TextStyle(fontWeight: FontWeight.w600, ),),
            onPressed: () {
              gUserBloc.removeUser();
              Navigator.pushNamed(context, '/user_login');
            },
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        syncBtn(context),
        Text(snapshot.error.toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800, ),),
      ],
    );
  }

  return syncBtn(context);
}

Widget syncHasDataInProcess(BuildContext context, SyncModel syncModel) {
  return Column(
    children: <Widget>[
      syncBtn(context, isEnable: false),
      Text(syncModel.message ?? '', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800, ),),
      CircularProgressIndicator(),
    ],
  );
}

Widget syncHasDataNotInProcess(BuildContext context, SyncModel syncModel) {
  return Column(
    children: <Widget>[
      syncBtn(context),
      Text(syncModel.message ?? '', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800, ),),
    ],
  );
}

Widget syncBtn(BuildContext context, {bool isEnable = true}) {
  return
    Align(
      alignment: Alignment.topLeft,
      child:
        FlatButton.icon(
          label: Text('Sync projects'),
          icon: Icon(Icons.exit_to_app, color: Colors.blue,),
          onPressed: isEnable ? onSyncCallback : null,
        ),
    );
}