import 'package:flutter/material.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/blocs/projects_bloc.dart';
import 'package:info_scanner_mobile/resources/common.dart';


class ProjectEditScreen extends StatefulWidget {
  final Project project;
  final ProjectsBloc bloc;

  //constructor
  ProjectEditScreen({Key key, this.project, @required this.bloc}) : super(key: key);

  @override
  _ProjectEditState createState() => _ProjectEditState(project, bloc);
}

const int nameMinLen = 1;
const int nameMaxLen = 25;
String nameValidator(String txt) {
  if (txt.length < nameMinLen || txt.length > nameMaxLen) {
    return 'Enter $nameMinLen - $nameMaxLen symbols';
  }

  return null;
}

class _ProjectEditState extends State<ProjectEditScreen> {
  ProjectsBloc bloc;
  Project project;
  static final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  bool isAddInfoVisible = false;

  //constructor
  _ProjectEditState(this.project, this.bloc) {
    _nameController.text = project?.name ?? 'new project';
    _noteController.text = project?.note;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _noteController.dispose();
    //bloc.dispose();

  }

  removeProjectCallback() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (p) => AlertDialog(
        title: Text('Do you want delete this project?'),
        content: Text(project.name),
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
        bloc.removeProject(project);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: showTitle(project),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.delete), onPressed: removeProjectCallback),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      //name
                      TextFormField(
                        controller: _nameController,
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(
                          hintText: 'Name'
                        ),
                        validator: nameValidator,
                      ),
                      //note
                      TextFormField(
                        controller: _noteController,
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(
                          hintText: 'Note'
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                
                Padding(padding: EdgeInsets.only(bottom: 20),),

                showAddInfo(project)
              ],
            ),
          )
        ),

        floatingActionButton:
          FloatingActionButton(
            child: showBtnAction(project),
            onPressed: onSaveCallback,
        ),
      );
  }

  onSaveCallback() {
    final form = formKey.currentState;
    if (form.validate()) {
      String name = _nameController.text;
      String note = _noteController.text;

      //add
      if (project == null) {
        Project p = new Project(name: name, note: note);
        bloc.addNewProject(p);
      } else {
        this.project.name = name;
        this.project.note = note;
        bloc.updateProject(this.project);
      }
      
      Navigator.pop(context);
    }
  }
}

Widget showTitle(Project project) {
  return project == null ? Text('Add project') : Text('Edit project');
}

Widget showBtnAction(Project project) {
  return project == null ? Icon(Icons.add) : Icon(Icons.edit);
}

Widget showProjectId(Project project) {
  //if (project == null)
  //  return Container();
  String projectId = '';
  if (project?.projectId != null) {
    projectId = project.projectId.toString();
  }

  return
    ListTile(
      leading: Text('project id'),
      title: Text(projectId, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.blue,),),
    );
    /*Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.vpn_key),
        Text(
          project.projectId.toString(),
          style: TextStyle(fontSize: 14)
        )
      ],
    );*/
}

Widget showProjectGuid(Project project) {
  if (project == null)
    return Container();

  return
    Expanded(
      child: Align(
        alignment: Alignment.bottomLeft,
        child:
          Text(
            project.projectGuid,
            style: TextStyle(fontSize: 14)
          )
      ),
    );
}

Widget showAddInfo(Project project) {
  if (project == null)
    return Container();

  TextStyle ts = TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.blue,);

  return
    Container(
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          showProjectId(project),
          ListTile(
            dense: true,
            leading: Text('begin date'),
            title: Text(Common.formatUnixDate(project?.unixBeginDate), style: ts,),
          ),
          ListTile(
            dense: true,
            leading: Text('project guid'),
            title: Text(project?.projectGuid??'', style: ts,),
          ),
          ListTile(
            dense: true,
            leading: Text('device guid'),
            title: Text(project?.deviceGuid??'', style: ts,),
          ),
          ListTile(
            dense: true,
            leading: Text('own project'),
            title: Text((project?.isOwnProject??1).toString(), style: ts,),
          ),
          ListTile(
            dense: true,
            leading: Text('last operation'),
            title: Text(project?.lastOperation??'', style: ts,),
          ),
          ListTile(
            dense: true,
            leading: Text('last change date'),
            title: Text(Common.formatUnixDate(project?.unixLastChangeDate), style: ts,),
          ),
        ],
      ),
    );
}