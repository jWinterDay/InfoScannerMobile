import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/project_model.dart';
import '../blocs/projects_bloc.dart';

class ProjectEditScreen extends StatefulWidget {
  final Project project;

  //constructor
  ProjectEditScreen({Key key, this.project}) : super(key: key);

  @override
  _ProjectEditState createState() => _ProjectEditState(project);
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
  Project project;
  static final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  //constructor
  _ProjectEditState(this.project) {
    _nameController.text = project.name;
    _noteController.text = project.note;
  }

  _onSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      project.name = _nameController.text;
      project.note = _noteController.text;
      
      bloc.updateProject(project);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text('Edit project'),
        ),

        body: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                //project id
                Text('id: ${project.projectId}', style: Theme.of(context).textTheme.title,),
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
                  //maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        
        floatingActionButton:
          FloatingActionButton(
            child: project == null ? Icon(Icons.add) : Icon(Icons.edit),
            onPressed: _onSave,
        ),
      );
  }
}