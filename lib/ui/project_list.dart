import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/project_model.dart';
import '../blocs/projects_bloc.dart';

class ProjectList extends StatefulWidget {

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  String _title = 'My projects';

  //add new project
  void _addProject() {
    var newProject = new Project();
    bloc.addNewProject(newProject);
  }

  @override
  void initState() {
    super.initState();
    bloc.fetchAllProjects();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: bloc.allProjects,
        builder: (context, AsyncSnapshot<List<Project>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: buildList(snapshot)
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

Widget buildList(AsyncSnapshot<List<Project>> snapshot) {
  final DateFormat dateFormatter = new DateFormat('yyyy.MM.dd HH:mm:ss');

  if (snapshot.data.isEmpty) {
    return Center(
      child: Text(
        'No data',
        style: TextStyle(fontSize: 30),
      )
    );
  }

  return GridView.builder(
    //scrollDirection: Axis.horizontal,
    itemCount: snapshot.data.length,
    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 5),
    itemBuilder: (BuildContext context, int index) {
      Project project = snapshot.data[index];
      String beginDateStr;
      if (project.beginDate != null) {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(project.beginDate);
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
                    duration: Duration(seconds: 5),
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
          decoration: project.endDate != null ? BoxDecoration(color: Colors.grey) : null,
          child: ListTile(
            leading: Text(project.projectId.toString()),
            title: Text(project.name),
            subtitle: Text('${beginDateStr??''} ${project.note??''}'),
            trailing: Checkbox(
              onChanged: (val) {
                /*if (val) {
                  bloc.restoreProject(project);
                } else {
                  bloc.preRemoveProject(project);
                }*/
              },
              value: project.endDate == null,
            ),
            onTap: () => {
              //print('tap'),
              //bloc.fetchAllProjects()
            },
          ),
        )
      );
    });
}