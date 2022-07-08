import 'dart:convert';
import 'dart:ui';
import 'dart:math' as math;
import "dart:async";

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wannasit_client/models/chairPositionModel/chairPositionModel.dart';
import 'package:wannasit_client/providers/chairsStateProvider/chairsStateProvider.dart';

//widgets
import './widgets/myTable/myTable.dart';

//providers
import 'package:wannasit_client/providers/googleSignInProvider/googleSignInProvider.dart';

class HomeTab extends StatefulWidget {
  final TabController _tabController;
  const HomeTab(this._tabController, {super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  bool connectServer = true;
  final User user = FirebaseAuth.instance.currentUser!;
  final List<List<dynamic>> suggestCard = [
    [Colors.green[300], "Avaliable chair"],
    [Colors.yellow[300], "Reserved chair"],
    [Colors.blue[300], "Your reserved chair"],
    [Colors.red[300], "Being seated chair"]
  ];

  late AnimationController _blurAnimationController;
  late CurvedAnimation _blurCurvedAnimation;
  late Animation<double> _blurAnimation;
  late Animation<Color?> _colorAnimtaion;

  late AnimationController _settingAnimationController;
  late Animation<double> _settingAnimation;

  ScrollController _tablesScrollController = ScrollController();
  ScrollController _suggestScrollController = ScrollController();

  ChairsStateProvider chairsStateProvider = ChairsStateProvider();

  Function()? updateTableStatePopup;

  @override
  void initState() {
    super.initState();
    _blurAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _blurCurvedAnimation = CurvedAnimation(
      curve: Curves.easeOut,
      parent: _blurAnimationController,
    );
    _blurAnimation =
        Tween<double>(begin: 0, end: 7.5).animate(_blurCurvedAnimation);

    _settingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _settingAnimation = Tween<double>(begin: 0, end: math.pi * 2).animate(
      CurvedAnimation(
        parent: _settingAnimationController,
        curve: Curves.easeOut,
      ),
    );

    syncData();
  }

  Future<void> syncData() async {
    if (connectServer) {
      await updateData();

      await Future.delayed(const Duration(seconds: 2));
      syncData();
    }
  }

  Future<void> updateData() async {
    chairsStateProvider.chairsState = jsonDecode((await http.post(
      Uri.parse("http://192.168.25.199/wannasit"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"from": "client", "for": "get", "uid": user.uid}),
    ))
        .body)["chairsState"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _colorAnimtaion = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).brightness == Brightness.light
          ? Colors.white30
          : Colors.black26,
    ).animate(
      _blurCurvedAnimation,
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: FlutterLogo(),
            ),
            title: const Text("Tables Status"),
            actions: [
              IconButton(
                onPressed: () async {
                  await _settingAnimationController.forward();
                  widget._tabController.animateTo(1);
                },
                icon: AnimatedBuilder(
                    animation: _settingAnimationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _settingAnimation.value,
                        child: Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 40,
                        ),
                      );
                    }),
              ),
              IconButton(
                onPressed: () async {
                  _blurAnimationController.forward();
                  await Navigator.of(context).push(
                    PageRouteBuilder(
                      barrierDismissible: true,
                      opaque: false,
                      transitionDuration: const Duration(seconds: 1),
                      reverseTransitionDuration:
                          const Duration(milliseconds: 500),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0, -1),
                            end: const Offset(0, 0),
                          ).chain(
                            CurveTween(curve: Curves.elasticOut),
                          ),
                        ),
                        child: child,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Center(
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "User Information",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Hero(
                                      tag: "profile",
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            NetworkImage(user.photoURL!),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.displayName!,
                                          style: const TextStyle(
                                            fontFamily: "Fc-Iconic",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            height: .75,
                                          ),
                                        ),
                                        Text(
                                          user.email!,
                                          style: const TextStyle(
                                            fontFamily: "Fc-Iconic",
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await Provider.of<GoogleSignInProvider>(
                                      context,
                                      listen: false,
                                    ).googleLogout();
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.logout),
                                  label: const Text("Logout"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  _blurAnimationController.reverse();
                },
                icon: Hero(
                  tag: "profile",
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size(0, 55),
              child: Scrollbar(
                controller: _suggestScrollController,
                child: SingleChildScrollView(
                  controller: _suggestScrollController,
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
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: chairsStateProvider.chairsState != null
                  ? OrientationBuilder(
                      builder: (context, orientation) {
                        bool isPortrait = orientation == Orientation.portrait;
                        return LayoutBuilder(
                          builder: (context, bodyConstraints) {
                            final List<List<dynamic>> tableChairSize = [
                              [
                                {
                                  "width": isPortrait
                                      ? bodyConstraints.maxWidth * .4
                                      : bodyConstraints.maxHeight * .2,
                                  "height": isPortrait
                                      ? bodyConstraints.maxWidth * .2
                                      : bodyConstraints.maxHeight * .4,
                                },
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
                                {
                                  "width": isPortrait
                                      ? bodyConstraints.maxWidth * .1
                                      : bodyConstraints.maxHeight * .1,
                                  "height": isPortrait
                                      ? bodyConstraints.maxWidth * .1
                                      : bodyConstraints.maxHeight * .1,
                                },
                                EdgeInsets.all(
                                  isPortrait
                                      ? bodyConstraints.maxWidth * .025
                                      : bodyConstraints.maxHeight * .025,
                                ),
                              ],
                            ];

                            final List<List<dynamic>> overlayChairsSize = [
                              [
                                {
                                  "width": isPortrait
                                      ? bodyConstraints.maxWidth * .8
                                      : bodyConstraints.maxHeight * .4,
                                  "height": isPortrait
                                      ? bodyConstraints.maxWidth * .4
                                      : bodyConstraints.maxHeight * .8,
                                },
                                EdgeInsets.symmetric(
                                  horizontal: isPortrait
                                      ? bodyConstraints.maxWidth * .05
                                      : 0,
                                  vertical: isPortrait
                                      ? 0
                                      : bodyConstraints.maxHeight * .05,
                                )
                              ],
                              [
                                {
                                  "width": isPortrait
                                      ? bodyConstraints.maxWidth * .2
                                      : bodyConstraints.maxHeight * .2,
                                  "height": isPortrait
                                      ? bodyConstraints.maxWidth * .2
                                      : bodyConstraints.maxHeight * .2,
                                },
                                EdgeInsets.all(
                                  isPortrait
                                      ? bodyConstraints.maxWidth * .05
                                      : bodyConstraints.maxHeight * .05,
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
                                            for (int j = 0; j < 2; j++)
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: () async {
                                                  _blurAnimationController
                                                      .forward();
                                                  await Navigator.of(context)
                                                      .push(
                                                    PageRouteBuilder(
                                                      barrierDismissible: true,
                                                      opaque: false,
                                                      transitionDuration:
                                                          const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                      reverseTransitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      transitionsBuilder: (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) =>
                                                          SlideTransition(
                                                        position:
                                                            animation.drive(
                                                          Tween<Offset>(
                                                            begin: const Offset(
                                                              0,
                                                              -1,
                                                            ),
                                                            end: const Offset(
                                                              0,
                                                              0,
                                                            ),
                                                          ).chain(
                                                            CurveTween(
                                                              curve: Curves
                                                                  .elasticOut,
                                                            ),
                                                          ),
                                                        ),
                                                        child: child,
                                                      ),
                                                      pageBuilder: (
                                                        context,
                                                        animation,
                                                        secondaryAnimation,
                                                      ) {
                                                        PopupTable popupTable =
                                                            PopupTable(
                                                          "$i-$j",
                                                          overlayChairsSize,
                                                          isPortrait,
                                                          chairsStateProvider,
                                                          ChairPositionModel(
                                                              row: i,
                                                              column: j == 1
                                                                  ? true
                                                                  : false,
                                                              side: false,
                                                              position: 0),
                                                          updateData,
                                                          true,
                                                        );
                                                        updateTableStatePopup = 
                                                      },
                                                    ),
                                                  );
                                                  _blurAnimationController
                                                      .reverse();
                                                },
                                                child: Hero(
                                                  tag: "$i-$j",
                                                  child: MyTable(
                                                    tableChairSize,
                                                    isPortrait,
                                                    chairsStateProvider,
                                                    ChairPositionModel(
                                                        row: i,
                                                        column: j == 1
                                                            ? true
                                                            : false,
                                                        side: false,
                                                        position: 0),
                                                    updateData,
                                                    false,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            for (int j = 0; j < 2; j++)
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: () async {
                                                  _blurAnimationController
                                                      .forward();
                                                  await Navigator.of(context)
                                                      .push(
                                                    PageRouteBuilder(
                                                      barrierDismissible: true,
                                                      opaque: false,
                                                      transitionDuration:
                                                          const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                      reverseTransitionDuration:
                                                          const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                      transitionsBuilder: (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) =>
                                                          SlideTransition(
                                                        position:
                                                            animation.drive(
                                                          Tween<Offset>(
                                                            begin: const Offset(
                                                              0,
                                                              -1,
                                                            ),
                                                            end: const Offset(
                                                              0,
                                                              0,
                                                            ),
                                                          ).chain(
                                                            CurveTween(
                                                              curve: Curves
                                                                  .elasticOut,
                                                            ),
                                                          ),
                                                        ),
                                                        child: child,
                                                      ),
                                                      pageBuilder: (
                                                        context,
                                                        animation,
                                                        secondaryAnimation,
                                                      ) =>
                                                          Hero(
                                                        tag: "$i-$j",
                                                        child: MyTable(
                                                          overlayChairsSize,
                                                          isPortrait,
                                                          chairsStateProvider,
                                                          ChairPositionModel(
                                                              row: i,
                                                              column: j == 1
                                                                  ? true
                                                                  : false,
                                                              side: false,
                                                              position: 0),
                                                          updateData,
                                                          true,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  _blurAnimationController
                                                      .reverse();
                                                },
                                                child: Hero(
                                                  tag: "$i-$j",
                                                  child: MyTable(
                                                    tableChairSize,
                                                    isPortrait,
                                                    chairsStateProvider,
                                                    ChairPositionModel(
                                                        row: i,
                                                        column: j == 1
                                                            ? true
                                                            : false,
                                                        side: false,
                                                        position: 0),
                                                    updateData,
                                                    false,
                                                  ),
                                                ),
                                              ),
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
                              controller: _tablesScrollController,
                              child: SingleChildScrollView(
                                controller: _tablesScrollController,
                                scrollDirection: isPortrait
                                    ? Axis.vertical
                                    : Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: isPortrait
                                        ? BoxConstraints(
                                            minHeight:
                                                bodyConstraints.maxHeight)
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
          ),
        ),
        AnimatedBuilder(
          animation: _blurAnimationController,
          builder: (context, child) {
            if (_blurAnimationController.value > 0) {
              return Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color: _colorAnimtaion.value,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    connectServer = false;
    _blurAnimationController.dispose();
    _suggestScrollController.dispose();
    _tablesScrollController.dispose();
    super.dispose();
  }
}
