import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//models
import "package:wannasit_client/models/chairPositionModel/chairPositionModel.dart";

//providers
import "package:wannasit_client/providers/chairsStateProvider/chairsStateProvider.dart";

class PopupTable extends StatefulWidget {
  final String heroTag;
  final ChairsStateProvider chairsStateProvider;
  final List<List<dynamic>> tableChairSize;
  final bool isPortrait;
  final ChairPositionModel chairPosition;
  final Future<void> Function() updateData;
  final bool isPopUp;
  const PopupTable(
      this.heroTag,
      this.tableChairSize,
      this.isPortrait,
      this.chairsStateProvider,
      this.chairPosition,
      this.updateData,
      this.isPopUp,
      {super.key});

  @override
  State<PopupTable> createState() => _PopupTableState();
}

class _PopupTableState extends State<PopupTable> {
  void updatePopupTableState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Hero(
          tag: widget.heroTag,
          child: MyTable(
            widget.tableChairSize,
            widget.isPortrait,
            widget.chairsStateProvider,
            widget.chairPosition,
            widget.updateData,
            widget.isPopUp,
          ),
        ),
      ),
    );
  }
}

class MyTable extends StatefulWidget {
  final ChairsStateProvider chairsStateProvider;
  final List<List<dynamic>> tableChairSize;
  final bool isPortrait;
  final ChairPositionModel chairPosition;
  final Future<void> Function() updateData;
  final bool isPopUp;
  const MyTable(this.tableChairSize, this.isPortrait, this.chairsStateProvider,
      this.chairPosition, this.updateData, this.isPopUp,
      {super.key});

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  @override
  Widget build(BuildContext context) {
    return widget.isPortrait
        ? FittedBox(
            fit: BoxFit.cover,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyChair(
                  widget.tableChairSize[1],
                  widget.isPortrait,
                  widget.chairsStateProvider,
                  ChairPositionModel(
                      row: widget.chairPosition.row,
                      column: widget.chairPosition.column,
                      side: false,
                      position: 0),
                  widget.updateData,
                  widget.isPopUp,
                ),
                Padding(
                  padding: widget.tableChairSize[0][1],
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: widget.tableChairSize[0][0]["width"],
                      maxHeight: widget.tableChairSize[0][0]["height"],
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                MyChair(
                  widget.tableChairSize[1],
                  widget.isPortrait,
                  widget.chairsStateProvider,
                  ChairPositionModel(
                    row: widget.chairPosition.row,
                    column: widget.chairPosition.column,
                    side: true,
                    position: 0,
                  ),
                  widget.updateData,
                  widget.isPopUp,
                ),
              ],
            ),
          )
        : FittedBox(
            fit: BoxFit.contain,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyChair(
                  widget.tableChairSize[1],
                  widget.isPortrait,
                  widget.chairsStateProvider,
                  ChairPositionModel(
                    row: widget.chairPosition.row,
                    column: widget.chairPosition.column,
                    side: false,
                    position: 0,
                  ),
                  widget.updateData,
                  widget.isPopUp,
                ),
                Padding(
                  padding: widget.tableChairSize[0][1],
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: widget.tableChairSize[0][0]["width"],
                      maxHeight: widget.tableChairSize[0][0]["height"],
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                MyChair(
                  widget.tableChairSize[1],
                  widget.isPortrait,
                  widget.chairsStateProvider,
                  ChairPositionModel(
                    row: widget.chairPosition.row,
                    column: widget.chairPosition.column,
                    side: true,
                    position: 0,
                  ),
                  widget.updateData,
                  widget.isPopUp,
                ),
              ],
            ),
          );
  }
}

class MyChair extends StatefulWidget {
  final ChairsStateProvider chairsStateProvider;
  final List<dynamic> chairSize;
  final bool isPortrait;
  final ChairPositionModel chairPosition;
  final Future<void> Function() updateData;
  final bool isPopUp;
  const MyChair(this.chairSize, this.isPortrait, this.chairsStateProvider,
      this.chairPosition, this.updateData, this.isPopUp,
      {super.key});

  @override
  State<MyChair> createState() => _MyChairState();
}

class _MyChairState extends State<MyChair> {
  final colorList = [
    Colors.green[200],
    Colors.yellow[200],
    Colors.red[200],
    Colors.blue[200],
  ];
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: widget.chairSize[1],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.isPortrait
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        curve: Curves.easeOut,
                        constraints: BoxConstraints(
                          maxWidth: widget.chairSize[0]["width"],
                          maxHeight: widget.chairSize[0]["height"],
                        ),
                        decoration: BoxDecoration(
                          color: colorList[widget.chairsStateProvider
                                      .chairsState![widget.chairPosition.row]
                                  [widget.chairPosition.column ? 1 : 0]
                              [widget.chairPosition.side ? 1 : 0][i]],
                          border: i == 1
                              ? Border.symmetric(
                                  vertical: BorderSide(
                                    color: Theme.of(context).canvasColor,
                                    width: 1,
                                  ),
                                )
                              : null,
                        ),
                        child: widget.isPopUp
                            ? Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    await widget.updateData();
                                    await http.post(
                                      Uri.parse(
                                          "http://192.168.25.199/wannasit"),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: jsonEncode({
                                        "from": "client",
                                        "for": "reserve",
                                        "uid": user.uid,
                                        "chairPosition": {
                                          "row": widget.chairPosition.row,
                                          "column": widget.chairPosition.column,
                                          "side": widget.chairPosition.side,
                                          "position": i,
                                        },
                                      }),
                                    );
                                    await widget.updateData();
                                    setState(() {});
                                  },
                                ),
                              )
                            : null,
                      ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        curve: Curves.easeOut,
                        constraints: BoxConstraints(
                          maxWidth: widget.chairSize[0]["width"],
                          maxHeight: widget.chairSize[0]["height"],
                        ),
                        decoration: BoxDecoration(
                          color: colorList[widget.chairsStateProvider
                                      .chairsState![widget.chairPosition.row]
                                  [widget.chairPosition.column ? 1 : 0]
                              [widget.chairPosition.side ? 1 : 0][i]],
                          border: i == 1
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                    color: Theme.of(context).canvasColor,
                                    width: 1,
                                  ),
                                )
                              : null,
                        ),
                        child: widget.isPopUp
                            ? Material(
                                child: InkWell(
                                  onTap: () async {
                                    await widget.updateData();
                                    await http.post(
                                      Uri.parse(
                                        "http://192.168.25.199/wannasit",
                                      ),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: jsonEncode(
                                        {
                                          "from": "client",
                                          "for": "reserve",
                                          "uid": user.uid,
                                          "chairPosition": {
                                            "row": widget.chairPosition.row,
                                            "column":
                                                widget.chairPosition.column,
                                            "side": widget.chairPosition.side,
                                            "position": i,
                                          },
                                        },
                                      ),
                                    );
                                    await widget.updateData();
                                    setState(() {});
                                  },
                                ),
                              )
                            : null,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
