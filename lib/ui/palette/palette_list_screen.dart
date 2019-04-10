import 'package:flutter/material.dart';
import 'package:info_scanner_mobile/models/diy_resource.dart';
import 'package:info_scanner_mobile/blocs/diy_resource_bloc.dart';
import 'dart:convert';

class PaletteListScreen extends StatefulWidget {
  @override
  _PaletteListState createState() => _PaletteListState();
}

class _PaletteListState extends State<PaletteListScreen> {
  final DiyResourceBloc bloc = DiyResourceBloc();
  TextEditingController searchController = new TextEditingController();
  List<DiyResource> initData;

  //constructor
  _PaletteListState() {
    setInitData();
    //searchController.addListener(() {});
  }

  setInitData() async {
    initData = await bloc.fetchAllDiyResources();
  }

  searchPalette() {
    bloc.fetchAllDiyResources(searchController.text);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Palette',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          //search
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon:  Icon(Icons.search),
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)
                ),
              ),

              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (val) {
                searchPalette();
              }
            ),
          ),

          //list
          StreamBuilder(
            initialData: initData,
            stream: bloc.allDiyResourcesStream,
            builder: (context, AsyncSnapshot<List<DiyResource>> snapshot) {
              if (snapshot.hasData) {
                //return Text(snapshot.data.length.toString());
                return Expanded(
                  child: buildList(snapshot)
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return Center(child: CircularProgressIndicator());
            },
          )
        ],
      )
    );
  }

  Widget buildList(AsyncSnapshot<List<DiyResource>> snapshot) {
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
        DiyResource diyResource = snapshot.data[index];
        String color = diyResource.color;
        Map<String, dynamic> colorJSON = json.decode(color);

        return Container(
          decoration: BoxDecoration(
            //backgroundBlendMode: BlendMode.difference,
            border: Border(bottom: BorderSide(color: Colors.grey[300])),//Border.all(color: Colors.black),
            color: diyResource.inMyPalette ? Colors.green : null//Theme.of(context).buttonColor// Colors.white
          ),
          child: ListTile(
            leading: Checkbox(
              onChanged: (val) {
                print(val);
              },
              value: diyResource.inMyPalette,
            ),
            title: Text(diyResource.no, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
            subtitle: Text(diyResource.name),
            trailing: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Color.fromARGB(255, colorJSON['R'], colorJSON['G'], colorJSON['B']),
              ),
              height: 40,
              width: 80,
            ),
            onTap: ()  { },
          ),
        );
    });
  }
}