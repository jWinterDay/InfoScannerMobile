import 'package:flutter/material.dart';

import 'package:info_scanner_mobile/blocs/schema_settings_bloc.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/models/schema_settings.dart';
import 'package:info_scanner_mobile/models/schema_tune.dart';
import 'package:info_scanner_mobile/models/schema_calc_method.dart';

class SchemaScreen extends StatefulWidget {
  final Project project;

  //constructor
  SchemaScreen({Key key, this.project, }) : super(key: key);

  @override
  _SchemaState createState() => _SchemaState(project);
}

class _SchemaState extends State<SchemaScreen> {
  Project project;
  SchemaSettingsBloc bloc = new SchemaSettingsBloc();

  //constructor
  _SchemaState(this.project);

  @override
  void initState() {
    super.initState();

    bloc.fetchSchemaTuneState();
    bloc.fetchSchemaCalcMethodState();
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
              _settingCaption('Method'),
              _buildSchemaCalcMethod(),
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

  Widget _buildSchemaCalcMethod() {
    return StreamBuilder(
      stream: bloc.schemaCalcMethodState,
      builder: (context, AsyncSnapshot<SchemaCalcMethodState> snapshot) {
        //print('snapshot = $snapshot');

        if (snapshot.hasData) {
          SchemaCalcMethodState state = snapshot.data;

          //error
          if (state.error != null) {
            return Text(state.error.toString());
          }

          List<Widget> list = new List();

          //methods
          List<Widget> methods = state.methodList.map((method) {
            return RadioListTile(
              title: Text(method.name, style: TextStyle(color: Color(Colors.blue.value))),
              groupValue: state.calcMethodId,
              value: method.methodId,
              activeColor: Color(Colors.red.value),
              onChanged: bloc.changeCurrentCalcMethodId,
            );
          }).toList();

          list.addAll(methods);

          //params
          if (methods.length > 0 && state.calcMethodId != null) {
            List<Widget> params = state.methodList
              .firstWhere((method) => method.methodId == state.calcMethodId)
              .paramList
              .map((param) {
                return TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.apps),
                    hintText: param.hint
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    print('val = $val');
                    //bloc.changeCalcMethodParam(val, paramId: param.paramId);
                  }
                );
              })
              .toList();

            list.addAll(params);
          }

          return Column(
            children: list
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
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
      //alignment: Alignment.topLeft,
    );
  }

  /*
  Widget _buildSchemaTune(AsyncSnapshot<SchemaSettings> snapshot) {
    SchemaSettings state = snapshot.data;

    //error
    if (state.error != null) {
      return Text(state.error.toString());
    }

    //schema tune (count list)
    return DropdownButtonFormField(
      hint: Text('Count list'),
      value: state.schemaTuneId,
      onChanged: bloc.changeCurrentSchemaTuneId,
      items: state.schemaTuneListState.list.map((p) => DropdownMenuItem(
        child: Text(p.name),
        value: p.schemaTuneId
      )).toList(growable: false),
    );
  }

  Widget _buildSchemaCalcMethod(AsyncSnapshot<SchemaSettings> snapshot) {
    SchemaSettings state = snapshot.data;

    //error
    if (state.error != null) {
      return Text(state.error.toString());
    }

    var list = new List<Widget>();
    var methods = state.schemaCalcMethod.methodList;

    methods.forEach((method) {
      //method
      list.add(
        RadioListTile(
          title: Text(method.name, style: TextStyle(color: Color(Colors.blue.value)),),
          groupValue: state.schemaCalcMethodId,
          value: method.methodId,
          activeColor: Color(Colors.red.value),
          onChanged: bloc.changeCurrentCalcMethodId,
        )
      );

      //param
      method.paramList.forEach((param) {
        list.add(TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.apps),
            enabled: (method.methodId == state.schemaCalcMethodId),
            //errorText: state.error.toString(),
            //icon: Icon(Icons.text_fields),
            hintText: param.hint
          ),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            bloc.changeCalcMethodParam(val, paramId: param.paramId);
          }
        ));
      });
    });

    return Column(
      children: list
    );
  }

  Widget _settingCaption(String caption) {
    TextStyle txtStyle = TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.blue, );

    return Container(
      child: Text(caption, style: txtStyle, ),
      padding: EdgeInsets.only(top: 15),
      //alignment: Alignment.topLeft,
    );
  }
  */
}