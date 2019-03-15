import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../blocs/projects_bloc.dart';

class ProjectList extends StatefulWidget {

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  String _title = 'My projects';

  void _addProject() {
    var newProject = new Project(name: 'first project');
    bloc.addNewProject(newProject);

    setState(() {
    //  _title = _titlePrefix + '.add';
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllProjects();

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
  if (snapshot.data.isEmpty) {
    return Center(
      child: Text(
        'No data',
        style: TextStyle(fontSize: 30),
      )
    );
  }

  return GridView.builder(
    itemCount: snapshot.data.length,//snapshot.data.results.length,
    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (BuildContext context, int index) {
      Project project = snapshot.data[index];

      return ListTile(
        title: Text(project.name, maxLines: 1,),
        leading: Text(project.projectId.toString()),
        //trailing: Text(project.beginDate.toString()),
        /*trailing: Checkbox(
          onChanged: (bool value) {
            DBProvider.db.blockClient(item);
            setState(() {});
          },
          value: item.blocked,
        ),*/
      );
      //return Text(
      //  '${snapshot.data[index].name} \n ${snapshot.data[index].beginDate}'// \n ${snapshot.data[index].projectGuid}'
      //);
    });
}