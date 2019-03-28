import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/blocs/projects_bloc.dart';

final DateFormat dateFormatter = new DateFormat('yyyy.MM.dd HH:mm:ss');

class ProjectEditScreen extends StatefulWidget {
  final Project project;
  final ProjectsBloc bloc;

  //constructor
  ProjectEditScreen({Key key, this.project, @required this.bloc}) : super(key: key);

  @override
  _ProjectEditState createState() => _ProjectEditState(project, bloc);
}

const int nameMinLen = 3;
const int nameMaxLen = 15;
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

  //constructor
  _ProjectEditState(this.project, this.bloc) {
    _nameController.text = project?.name;
    _noteController.text = project?.note;
  }

  @override
  void dispose() {
    super.dispose();
    //bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        appBar: AppBar(
          title: _showTitle(project),
        ),

        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              //project id
              _showProjectId(project),
              //begin date
              _showProjectBeginDate(project),
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
              //_showProjectBeginDate(project),
              _showProjectGuid(project),
            ],
          ),
        ),
        
        floatingActionButton:
          FloatingActionButton(
            child: _showBtnAction(project),
            onPressed: _onSave,
        ),
      );
  }

  _onSave() {
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

Widget _showTitle(Project project) {
  return project == null ? Text('Add project') : Text('Edit project');
}

Widget _showBtnAction(Project project) {
  return project == null ? Icon(Icons.add) : Icon(Icons.edit);
}

Widget _showProjectBeginDate(Project project) {
  if (project == null || project.unixBeginDate == null)
    return Container(); 

  DateTime dt = DateTime.fromMillisecondsSinceEpoch(project.unixBeginDate);
  String beginDateStr = dateFormatter.format(dt);

  return
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.date_range),
        Text(
          beginDateStr,
          style: TextStyle(fontSize: 14)
        )
      ],
    );
}

Widget _showProjectId(Project project) {
  if (project == null)
    return Container();

  return
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.vpn_key),
        Text(
          project.projectId.toString(),
          style: TextStyle(fontSize: 14)
        )
      ],
    );
}

Widget _showProjectGuid(Project project) {
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