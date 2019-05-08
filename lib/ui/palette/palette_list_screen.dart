import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:core';
import 'dart:ui';
import 'dart:convert';

import 'package:info_scanner_mobile/models/diy_resource.dart';
import 'package:info_scanner_mobile/blocs/diy_resource_bloc.dart';

class PaletteListScreen extends StatefulWidget {
  @override
  _PaletteListState createState() => _PaletteListState();
}

class _PaletteListState extends State<PaletteListScreen> {
  final DiyResourceBloc bloc = DiyResourceBloc();
  DiyResourceListState _initData;
  ScrollController _scrollController;

  //constructor
  _PaletteListState() {
    _scrollController = new ScrollController();
    _setInitData();
  }

  _setInitData() async {
    _initData = await bloc.loadFirst();
  }

  _setInMyPalette(BuildContext context, DiyResource diyResource, bool val) {
    bloc.setInMyPalette(diyResource, val: val);

    /*Scaffold
      .of(context)
      .showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('${diyResource.name}'),
        )
      );*/
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
                bloc.search(val);
              }
            ),
          ),

          //list
          StreamBuilder(
            initialData: _initData,
            stream: bloc.list,
            builder: (context, AsyncSnapshot<DiyResourceListState> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: buildList(snapshot)
                );
              } else if (snapshot.hasError) {
                return
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(snapshot.error.toString()),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  Widget buildList(AsyncSnapshot<DiyResourceListState> snapshot) {
    DiyResourceListState state = snapshot.data;

    if (snapshot.data.list != null && snapshot.data.list.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: TextStyle(fontSize: 30),
        )
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          if (_scrollController.position.extentAfter == 0) {
            bloc.loadMore();
          }
        }
        return false;
      },
      child: ListView.separated(
        //physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: snapshot.data.list == null ? 0 : snapshot.data.list.length + 1,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          //list
          if (index < state.list.length) {
            DiyResource diyResource = state.list[index];
            String color = diyResource.color;
            Map<String, dynamic> colorJSON = json.decode(color);

            return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300])),
                color: diyResource.inMyPalette ? Colors.green[100] : null
              ),
              child: ListTile(
                leading: Checkbox(
                  onChanged: (val) {
                    _setInMyPalette(context, diyResource, val);
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
                  height: 30,
                  width: 70,
                ),
                onTap: ()  { },
              ),
            );
          }

          //error
          /*if (snapshot.error != null) {
            return ListTile(
              title: Text(
                'Error while loading data...',
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
              ),
              isThreeLine: false,
              leading: CircleAvatar(
                child: Text(snapshot.error),
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
              ),
            );
          }*/

          //load more
          if (state.isLoadedAll) {
            return Container();
          }

          return Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.red)),
              color: Colors.grey[300]
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: loadMore(context, state), 
            )
          );
        },
      )
    );
  }

  Widget loadMore(BuildContext context, DiyResourceListState state) {
    if (state.isLoading) {
      return Center(
        child: Opacity(
          opacity: 1,
          child: CircularProgressIndicator(strokeWidth: 2.0,),
        ),
      );
    }

    Widget errInfo = (state.error == null) ?
      Container() : Text(state.error.toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),);

    return Center(
      child: Column(
        children: <Widget>[
          errInfo,
          FlatButton.icon(
            label: Text('Load more', style: TextStyle(color: Colors.blue),),
            icon: Icon(Icons.get_app),
            onPressed: () => {
              bloc.loadMore()
            },
          )
        ],
      )
    );
  }
}