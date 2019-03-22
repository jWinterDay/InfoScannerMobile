import 'package:flutter/material.dart';

class PaletteListScreen extends StatefulWidget {
  @override
  _PaletteListState createState() => _PaletteListState();
}

class _PaletteListState extends State<PaletteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Palette',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, top: 16),
        child: Text('palette'),
      )
    );
  }
}