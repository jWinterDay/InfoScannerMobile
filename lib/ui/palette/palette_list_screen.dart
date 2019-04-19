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
  TextEditingController _searchController = new TextEditingController();
  //List<DiyResource> _initData;
  DiyResourceListState _initData;

  static const int LIMIT_PER_PAGE = 10;
  ScrollController _scrollController;
  //bool _isAvailableLoadMore = true;

  //constructor
  _PaletteListState() {
    _scrollController = new ScrollController();
    _searchController.text = '';
    _setInitData();

    //when controller is changed, reinitialize offset
    //_searchController.addListener(() {
    //  _isAvailableLoadMore = true;
    //});

    /*bloc.allDiyResourcesStream.listen((data) {
      _isAvailableLoadMore = true;
    });*/
    //bloc.loadMoreController.stream.listen((data) {
    //  _isAvailableLoadMore = true;
    //});
  }

  _setInitData() async {
    _initData = await bloc.initData();
    //_initData = await bloc.fetchAllDiyResources(offset: _offset, limit: _limit);
  }

  _searchPalette() {
    //bloc.fetchAllDiyResources(filter: _searchController.text);
  }

  _loadMore() {
    print('I want to get more');
    bloc.loadMoreResultData(filter: _searchController.text);
    //_limit += LIMIT_PER_PAGE;
    //_offset += LIMIT_PER_PAGE;
    //bloc.fetchAllDiyResources(limit: _limit, offset: _offset);//, limit: LIMIT_PER_PAGE);//, limit: _limit);
    //_isAvailableLoadMore = true;
  }

  _setInMyPalette(BuildContext context, DiyResource diyResource, bool val) {
    bloc.setInMyPalette(diyResource.diyResourceId, val: val, filter: _searchController.text);
    Scaffold
      .of(context)
      .showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('${diyResource.name}'),
        )
      );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    bloc.dispose();
    //_searchController.removeListener(() { });
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
              controller: _searchController,
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
                _searchPalette();
              }
            ),
          ),

          //list
          StreamBuilder(
            initialData: _initData,
            //stream: bloc.allDiyResourcesStream,
            stream: bloc.listStream,//bloc.initStream,// resultStream,
            //builder: (context, AsyncSnapshot<List<DiyResource>> snapshot) {
            builder: (context, AsyncSnapshot<DiyResourceListState> snapshot) {
              //print('snapshot = ${snapshot.data}');

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
            _loadMore();
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
          final isLoading = snapshot.data.isLoading;

          //list
          if (index < snapshot.data.list.length) {
            DiyResource diyResource = snapshot.data.list[index];
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
                title: Text('$index ] ${diyResource.no}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
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
          return Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.red)),
              color: Colors.grey[300]
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: loadMore(context, isLoading, snapshot.data.error), 
            )
          );
          //return loadMore(context, isLoading);
        },
      )
      
    );
  }

  Widget loadMore(BuildContext context, bool isLoading, Object error) {
    if (isLoading) {
      return Center(
        child: Opacity(
          opacity: 1,
          child: CircularProgressIndicator(strokeWidth: 2.0,),
        ),
      );
    }

    Widget errInfo = (error == null) ? Container() : Text(error.toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),);

    return Center(
      child: Column(
        children: <Widget>[
          errInfo,
          FlatButton.icon(
            label: Text('Load more', style: TextStyle(color: Colors.blue),),
            icon: Icon(Icons.get_app),
            onPressed: () => { _loadMore() },
          )
        ],
      )
    );
  }
}

/*child: GridView.builder(
        controller: _scrollController,
        itemCount: snapshot.data.length,
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
                  _setInMyPalette(context, diyResource, val);
                },
                value: diyResource.inMyPalette,
              ),
              title: Text('$index ] ${diyResource.no}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
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
      })*/

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