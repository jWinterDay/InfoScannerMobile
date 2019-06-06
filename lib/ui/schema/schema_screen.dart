import 'package:flutter/material.dart';

import 'package:info_scanner_mobile/blocs/schema_settings_bloc.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/models/schema_settings/schema_tune.dart';
import 'package:info_scanner_mobile/models/schema_settings/schema_size.dart';

class SchemaScreen extends StatefulWidget {
  final Project project;

  //constructor
  SchemaScreen({Key key, this.project, }) : super(key: key);

  @override
  _SchemaState createState() => _SchemaState(project);
}

class _SchemaState extends State<SchemaScreen> {
  final Project project;
  final SchemaSettingsBloc bloc = new SchemaSettingsBloc();
  TextEditingController _schemaStateSizeWidthCtrl;
  TextEditingController _schemaStateSizeHeightCtrl;

  //constructor
  _SchemaState(this.project);

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  initAsync() async {
    bloc.fetchSchemaTuneState();
    SchemaSizeState sizeState = await bloc.fetchSchemaSizeState();

    _schemaStateSizeWidthCtrl = new TextEditingController(text: sizeState.sizeParam.width?.toString());
    _schemaStateSizeHeightCtrl = new TextEditingController(text: sizeState.sizeParam.height?.toString());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Schema. (${project.projectId.toString()}/${project.name})'),
          actions: <Widget>[
            //IconButton(icon: Icon(Icons.delete), onPressed: removeProjectCallback),
          ],
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _settingCaption('Count'),
              _buildSchemaTune(),
              _settingCaption('Size'),
              _buildSchemaSize(),
            ],
          ),
        ),
      );
  }

  Widget _buildSchemaTune() {
    return StreamBuilder(
      stream: bloc.schemaTuneState,
      builder: (context, AsyncSnapshot<SchemaTuneState> snapshot) {
        if (snapshot.hasData) {
          SchemaTuneState state = snapshot.data;

          //error
          if (state.error != null) {
            return Text(state.error.toString());
          }

          //schema tune (count list)
          return DropdownButtonFormField(
            hint: Text('Count list'),
            value: state.schemaTuneId,
            onChanged: bloc.changeCurrentSchemaTuneId,
            items: state.list.map((p) => DropdownMenuItem(
              child: Text(p.name),
              value: p.schemaTuneId
            )).toList(growable: false),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        
        return Center(child: CircularProgressIndicator());
      }
    );
  }

  _stateSizeChangeHandler(String val) {
    String width = _schemaStateSizeWidthCtrl.value.text;
    String height = _schemaStateSizeHeightCtrl.value.text;

    bloc.changeSize(width, height);
  }

  Widget _buildSchemaSize() {
    return StreamBuilder(
      stream: bloc.schemaSizeState,
      builder: (context, AsyncSnapshot<SchemaSizeState> snapshot) {
        if (snapshot.hasData) {
          SchemaSizeState state = snapshot.data;

          //error
          if (state.error != null) {
            return Text(state.error.toString());
          }

          return Column(
            children: <Widget>[
              TextField(
                controller: _schemaStateSizeWidthCtrl,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.apps),
                  hintText: 'Width'
                ),
                keyboardType: TextInputType.number,
                onChanged: _stateSizeChangeHandler,

              ),
              TextField(
                controller: _schemaStateSizeHeightCtrl,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.apps),
                  hintText: 'Height'
                ),
                keyboardType: TextInputType.number,
                onChanged: _stateSizeChangeHandler,
              ),
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }

  Widget _settingCaption(String caption) {
    TextStyle txtStyle = TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.blue, );

    return Container(
      child: Text(caption, style: txtStyle, ),
      padding: EdgeInsets.only(top: 15),
    );
  }
}