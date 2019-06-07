import 'package:flutter/material.dart';
import 'package:info_scanner_mobile/ui/components/footer_common_info.dart';
import 'package:intl/intl.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/blocs/projects_bloc.dart';
import 'package:info_scanner_mobile/ui/project/project_edit_screen.dart';
import 'package:info_scanner_mobile/ui/schema/schema_screen.dart';

//final ProjectsBloc bloc = ProjectsBloc();//ProjectsBloc();

class ProjectListScreen extends StatefulWidget {

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectListScreen> {
  final ProjectsBloc bloc = ProjectsBloc();

  void _addProject() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ProjectEditScreen(project: null, bloc: bloc,);
        }
      ),
    );
  }

  void refreshProjects() {
    bloc.fetchAllProjects();
  }

  void removeAllProjects() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (p) => AlertDialog(
        title: Text('Do you want delete all projects?'),
        //content: Text(project.name),
        actions: <Widget>[
          //cancel
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () { Navigator.of(this.context).pop(false); }
          ),
          //remove
          IconButton(
            icon: Icon(Icons.delete, color: Colors.blue),
            onPressed: () { Navigator.of(this.context).pop(true); }
          ),
        ],
      )
    ).then((dialogResult) {
      if (dialogResult) {
        bloc.removeAllProjects();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllProjects();

    return Scaffold(
      appBar: AppBar(
        title: Text('My projects'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.sync), onPressed: refreshProjects),
          IconButton(icon: Icon(Icons.delete), onPressed: removeAllProjects),
        ],
      ),
      bottomNavigationBar: footerCommonInfo(isNavigator: true),
      //persistentFooterButtons: <Widget>[
      //  footerCommonInfo(),
      //],
      body: StreamBuilder(
        stream: bloc.allProjectsStream,
        builder: (context, AsyncSnapshot<List<Project>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: buildList(snapshot, bloc: bloc)
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _addProject,
                tooltip: 'Add project',
                child: Icon(Icons.add)
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}

Widget buildList(AsyncSnapshot<List<Project>> snapshot, {@required ProjectsBloc bloc }) {
  final DateFormat dateFormatter = new DateFormat('yyyy.MM.dd HH:mm:ss');

  editProject(BuildContext context, Project project) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ProjectEditScreen(project: project, bloc: bloc,);
        }
      ),
    );
  }

  viewSchema(BuildContext context, Project project) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SchemaScreen(project: project);
        }
      ),
    );
  }

  if (snapshot.data.isEmpty) {
    return Center(
      child: Text(
        'No data',
        style: TextStyle(fontSize: 30),
      )
    );
  }

  return GridView.builder(
    itemCount: snapshot.data.length,
    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 5),
    itemBuilder: (BuildContext context, int index) {
      Project project = snapshot.data[index];
      String beginDateStr;
      if (project.unixBeginDate != null) {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(project.unixBeginDate);
        beginDateStr = dateFormatter.format(dt);
      }

      return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.blue),
        //secondaryBackground: Container(color: Colors.green),
        confirmDismiss: (direction) { return bloc.isCanRemoveProject(project); },
        onDismissed: (direction) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (p) => AlertDialog(
              title: Text('Do you want delete this project?'),
              content: Text(project.name),
              actions: <Widget>[
                //cancel
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.blue),
                  onPressed: () { Navigator.of(context).pop(false); }
                ),
                //remove
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.blue),
                  onPressed: () { Navigator.of(context).pop(true); }
                ),
              ],
            )
          ).then((dialogResult) {
            if (dialogResult) {
              //just set end_date
              bloc.preRemoveProject(project);

              Scaffold
                .of(context)
                .showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: Row(
                      children: <Widget>[
                        Text('${project.name} removed'),
                        //undo removing
                        IconButton(
                          icon: Icon(Icons.undo, color: Colors.blue),
                          onPressed: () {
                            Scaffold.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
                            bloc.restoreProject(project);
                          }
                        )
                      ],
                    ),
                  )
                )
                .closed
                .then((reason) {
                  //delete permanently om closed SnackBar
                  if (reason == SnackBarClosedReason.timeout) {
                    bloc.removeProject(project);
                  }
                });
            } else {
              //just refresh on dialog cancel
              bloc.fetchAllProjects();
            }
          });
        },
        child: Container(
          //decoration: UnderlineTabIndicator(borderSide: BorderSide(), insets: EdgeInsets.all(5)),
          decoration: project.unixEndDate != null ? BoxDecoration(color: Colors.grey) : null,
          child: ListTile(
            leading: FlatButton.icon(
              icon: Icon(Icons.edit),
              label: Text(project.projectId.toString()),
              onPressed: () {
                editProject(context, project);
              },
            ),
            title: Text(project.name),
            subtitle: Text('${beginDateStr??''} ${project.note??''}'),
            onTap: ()  {
              viewSchema(context, project);
            },
          ),
        )
      );
    });
}