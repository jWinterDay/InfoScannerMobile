import 'package:flutter/material.dart';
import 'dart:math' as math;
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
  TextEditingController searchController = new TextEditingController();
  List<DiyResource> initData;
  
  ScrollController scrollController;
  int _rowsPerPage = 10;
  int _nextLoadCount = 0;

  //constructor
  _PaletteListState() {
    scrollController = new ScrollController();
    searchController.text = '';
    setInitData();
  }

  setInitData() async {
    initData = await bloc.fetchAllDiyResources(offset: 0, limit: _rowsPerPage);
  }

  searchPalette() {
    bloc.fetchAllDiyResources(offset: _rowsPerPage * _nextLoadCount, limit: _rowsPerPage, filter: searchController.text);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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

  Widget buildList(AsyncSnapshot<List<DiyResource>> snapshot) {
    if (snapshot.data.isEmpty) {
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
          if (scrollController.position.extentAfter == 0) {
            print('go load');
            //loadMore();
          }
        }
        return false;
      },
      child: GridView.builder(
        controller: scrollController,
        itemCount: 20,//snapshot.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 7),
        itemBuilder: (BuildContext context, int index) {
          DiyResource diyResource = snapshot.data[index];
          String color = diyResource.color;
          Map<String, dynamic> colorJSON = json.decode(color);

          return Container(
            decoration: BoxDecoration(
              //backgroundBlendMode: BlendMode.difference,
              border: Border(bottom: BorderSide(color: Colors.grey[300])),//Border.all(color: Colors.black),
              color: diyResource.inMyPalette ? Colors.green[100] : null//Theme.of(context).buttonColor// Colors.white
            ),
            child: ListTile(
              leading: Checkbox(
                onChanged: (val) {
                  bloc.setInMyPalette(diyResource.diyResourceId, val: val, filter: searchController.text);
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
      })
    );
  }
}

/*return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(2),
      children: <Widget>[
        PaginatedDataTable(
          header: const Text(''),
          source: PaletteDataSource(),
          rowsPerPage: _rowsPerPage,
          onPageChanged: (firstRowIndex) {
            //scrollController.position.jumpTo(scrollController.position.minScrollExtent);
          },
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.ac_unit),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.account_balance),
              onPressed: null,
            ),
          ],
          availableRowsPerPage: [5, 10, 20, 50],
          onRowsPerPageChanged: (int val) {
            print(val);
            setState(() {
              _rowsPerPage = val;  
            });
          },
          onSelectAll: (val) {
            print(val);
          },
          //onRowsPerPageChanged: (int value) { setState(() { 5 = value; }); },
          sortColumnIndex: 0,
          sortAscending: false,
          columns: <DataColumn>[
            DataColumn(
              label: new Text('Rank', style: new TextStyle(fontSize: 20, color: Colors.blue[700])),
              numeric: false,
                //onSort: (int columnIndex, bool ascending) => _sort<num>((Player d) => d.rank, columnIndex, ascending)
            ),
            new DataColumn(
              label: new Text('Prev', style: new TextStyle(fontSize: 20, color: Colors.blue[700])),
              numeric: true,
                //onSort: (int columnIndex, bool ascending) => _sort<num>((Player d) => d.prevRank, columnIndex, ascending)
            ),
          ]
        )
      ]
    );

class PaletteDataSource extends DataTableSource {
  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text('row #$index', style: TextStyle(fontSize: 20),),
        ),
        DataCell(
          Row(
            children: <Widget>[
              Text('name #$index', style: TextStyle(fontSize: 20),)
            ],
          ),
          
        ),
      ],
    );
  }

  int get rowsPerPage => 10;

  @override
  int get rowCount => 150;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}*/