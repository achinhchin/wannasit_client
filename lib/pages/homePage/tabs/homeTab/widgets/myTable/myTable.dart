import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyTable extends StatefulWidget {
  final List<List<EdgeInsets>> tableChairSize;
  final bool isPortrait;
  const MyTable(this.tableChairSize, this.isPortrait, {super.key});

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  @override
  Widget build(BuildContext context) {
    return widget.isPortrait
        ? Column(
            children: [
              MyChair(widget.tableChairSize[1], widget.isPortrait),
              Padding(
                padding: widget.tableChairSize[0][1],
                child: Container(
                  padding: widget.tableChairSize[0][0],
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              MyChair(widget.tableChairSize[1], widget.isPortrait),
            ],
          )
        : Row(
            children: [
              MyChair(widget.tableChairSize[1], widget.isPortrait),
              Padding(
                padding: widget.tableChairSize[0][1],
                child: Container(
                  padding: widget.tableChairSize[0][0],
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              MyChair(widget.tableChairSize[1], widget.isPortrait),
            ],
          );
  }
}

class MyChair extends StatefulWidget {
  final List<EdgeInsets> chairSize;
  final bool isPortrait;
  const MyChair(this.chairSize, this.isPortrait, {super.key});

  @override
  State<MyChair> createState() => _MyChairState();
}

class _MyChairState extends State<MyChair> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.chairSize[1],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: widget.isPortrait
            ? Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Container(
                      padding: widget.chairSize[0],
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        border: i == 1
                            ? Border.symmetric(
                                vertical: BorderSide(
                                  color: Theme.of(context).canvasColor,
                                  width: 1,
                                ),
                              )
                            : null,
                      ),
                    ),
                ],
              )
            : Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    Container(
                      padding: widget.chairSize[0],
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        border: i == 1
                            ? Border.symmetric(
                                horizontal: BorderSide(
                                  color: Theme.of(context).canvasColor,
                                  width: 1,
                                ),
                              )
                            : null,
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
