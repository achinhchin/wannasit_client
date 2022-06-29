import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//widgets
import './widgets/myTable/myTable.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<List<dynamic>> suggestCard = [
    [Colors.green[300], "Avaliable chair"],
    [Colors.yellow[300], "Reserved chair"],
    [Colors.blue[300], "Your reserved chair"],
    [Colors.red[300], "Not avaliable chair"]
  ];

  List<List<List<List<int>>>>? tablesState;

  @override
  void initState() {
    super.initState();
    tablesState = [
      [
        [
          [0, 0, 0],
          [0, 0, 0]
        ],
        [
          [0, 0, 0],
          [0, 0, 0]
        ]
      ],
      [
        [
          [0, 0, 0],
          [0, 0, 0]
        ],
        [
          [0, 0, 0],
          [0, 0, 0]
        ]
      ],
      [
        [
          [0, 0, 0],
          [0, 0, 0]
        ],
        [
          [0, 0, 0],
          [0, 0, 0]
        ]
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: FlutterLogo(),
        ),
        title: const Text("Tables Status"),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(
              Icons.settings,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size(0, 55),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(7.5),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: suggestCard[i][0],
                                ),
                              ),
                              const SizedBox(
                                width: 7.5,
                              ),
                              Text(suggestCard[i][1]),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: tablesState != null
            ? OrientationBuilder(
                builder: (context, orientation) {
                  bool isPortrait = orientation == Orientation.portrait;
                  return LayoutBuilder(
                    builder: (context, bodyConstraints) {
                      final List<List<EdgeInsets>> tableChairSize = [
                        [
                          EdgeInsets.symmetric(
                            horizontal: isPortrait
                                ? bodyConstraints.maxWidth * .2
                                : bodyConstraints.maxHeight * .1,
                            vertical: isPortrait
                                ? bodyConstraints.maxWidth * .1
                                : bodyConstraints.maxHeight * .2,
                          ),
                          EdgeInsets.symmetric(
                            horizontal: isPortrait
                                ? bodyConstraints.maxWidth * .025
                                : 0,
                            vertical: isPortrait
                                ? 0
                                : bodyConstraints.maxHeight * .025,
                          )
                        ],
                        [
                          EdgeInsets.symmetric(
                            horizontal: isPortrait
                                ? bodyConstraints.maxWidth * .05
                                : bodyConstraints.maxHeight * .05,
                            vertical: isPortrait
                                ? bodyConstraints.maxWidth * .05
                                : bodyConstraints.maxHeight * .05,
                          ),
                          EdgeInsets.all(
                            isPortrait
                                ? bodyConstraints.maxWidth * .025
                                : bodyConstraints.maxHeight * .025,
                          ),
                        ],
                      ];
                      List<Widget> tablesView = [
                        Text(
                          isPortrait ? "สหกรณ์" : "ส\nห\nก\nร\nณ์",
                          style: const TextStyle(
                            fontSize: 30,
                            fontFamily: "FC-Iconic",
                            height: 1,
                          ),
                        ),
                        isPortrait
                            ? const Divider(
                                color: Colors.grey,
                                indent: 50,
                                endIndent: 50,
                                thickness: 2.5,
                              )
                            : const VerticalDivider(
                                color: Colors.grey,
                                indent: 50,
                                endIndent: 50,
                                thickness: 2.5,
                              ),
                      ];
                      tablesView.addAll(
                        [
                          for (int i = 0; i < 5; i++)
                            isPortrait
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      MyTable(tableChairSize, isPortrait),
                                      MyTable(tableChairSize, isPortrait),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      MyTable(tableChairSize, isPortrait),
                                      MyTable(tableChairSize, isPortrait),
                                    ],
                                  )
                        ],
                      );
                      tablesView.addAll(
                        [
                          isPortrait
                              ? const Divider(
                                  color: Colors.grey,
                                  indent: 50,
                                  endIndent: 50,
                                  thickness: 2.5,
                                )
                              : const VerticalDivider(
                                  color: Colors.grey,
                                  indent: 50,
                                  endIndent: 50,
                                  thickness: 2.5,
                                ),
                          Text(
                            isPortrait ? "อาคาร 2" : "อ\nา\nค\nา\nร\n\n2",
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: "FC-Iconic",
                              height: 1,
                            ),
                          ),
                        ],
                      );
                      return Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection:
                              isPortrait ? Axis.vertical : Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: isPortrait
                                  ? BoxConstraints(
                                      minHeight: bodyConstraints.maxHeight)
                                  : BoxConstraints(
                                      minWidth: bodyConstraints.maxWidth),
                              child: isPortrait
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: tablesView,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: tablesView,
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
