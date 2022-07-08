import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:firebase_auth/firebase_auth.dart";

//models
import 'package:wannasit_client/models/appThemeModel/appThemeModel.dart';

//providers
import 'package:wannasit_client/providers/appThemeProvider/appThemeProvider.dart';
import 'package:wannasit_client/providers/googleSignInProvider/googleSignInProvider.dart';

class SettingsTab extends StatefulWidget {
  final TabController _tabController;
  const SettingsTab(this._tabController, {super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab>
    with SingleTickerProviderStateMixin {
  final TextStyle _titleSettingTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  final ScrollController _scrollController = ScrollController();

  late ThemeMode _themeModeController;
  late int _lightColorController;
  late int _darkColorController;

  late AnimationController _blurAnimationController;
  late CurvedAnimation _blurCurvedAnimation;
  late Animation<double> _blurAnimation;
  late Animation<Color?> _colorAnimtaion;

  final List<int> colorList = [
    0xff2196f3,
    0xffff5252,
    0xff9c27b0,
    0xffff9800,
    0xffffeb3b,
    0xff4caf50,
  ];

  @override
  void initState() {
    super.initState();
    final AppThemeProvider appThemeProvider =
        Provider.of<AppThemeProvider>(context, listen: false);
    _themeModeController = appThemeProvider.appTheme.themeMode;
    _lightColorController = appThemeProvider.appTheme.lightColor;
    _darkColorController = appThemeProvider.appTheme.darkColor;

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

    final User user = FirebaseAuth.instance.currentUser!;
    final AppThemeProvider appThemeProvider =
        Provider.of<AppThemeProvider>(context, listen: false);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                widget._tabController.animateTo(0);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            title: const Text("Settings"),
            actions: [
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
          ),
          body: SafeArea(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Themes & Appearance",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Theme Mode",
                                        style: _titleSettingTextStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: CupertinoSegmentedControl<
                                            ThemeMode>(
                                          groupValue: _themeModeController,
                                          children: const {
                                            ThemeMode.dark: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text("Dark Mode"),
                                            ),
                                            ThemeMode.system: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text("On System"),
                                            ),
                                            ThemeMode.light: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text("Light Mode"),
                                            ),
                                          },
                                          onValueChanged: ((value) async {
                                            setState(() {
                                              _themeModeController = value;
                                            });
                                            await appThemeProvider.setAppTheme(
                                              AppThemeModel(
                                                themeMode: _themeModeController,
                                                lightColor:
                                                    _lightColorController,
                                                darkColor: _darkColorController,
                                              ),
                                            );
                                          }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Light Color",
                                        style: _titleSettingTextStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int i = 0;
                                                  i < colorList.length;
                                                  i++)
                                                Transform.scale(
                                                  scale: 1.5,
                                                  child: Radio(
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(Color(
                                                                colorList[i])),
                                                    value: colorList[i],
                                                    groupValue:
                                                        _lightColorController,
                                                    onChanged: (value) async {
                                                      setState(
                                                        () {
                                                          _lightColorController =
                                                              value as int;
                                                        },
                                                      );
                                                      await appThemeProvider
                                                          .setAppTheme(
                                                        AppThemeModel(
                                                          themeMode:
                                                              _themeModeController,
                                                          lightColor:
                                                              _lightColorController,
                                                          darkColor:
                                                              _darkColorController,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Dark Color",
                                        style: _titleSettingTextStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int i = 0;
                                                  i < colorList.length;
                                                  i++)
                                                Transform.scale(
                                                  scale: 1.5,
                                                  child: Radio(
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(Color(
                                                                colorList[i])),
                                                    value: colorList[i],
                                                    groupValue:
                                                        _darkColorController,
                                                    onChanged: (value) async {
                                                      setState(
                                                        () {
                                                          _darkColorController =
                                                              value as int;
                                                        },
                                                      );
                                                      await appThemeProvider
                                                          .setAppTheme(
                                                        AppThemeModel(
                                                          themeMode:
                                                              _themeModeController,
                                                          lightColor:
                                                              _lightColorController,
                                                          darkColor:
                                                              _darkColorController,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "App Data",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Card(
                                child: ListTile(
                                  leading: Text(
                                    "Package Name",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("com.evyting.wannasit"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Card(
                                child: ListTile(
                                  leading: Text(
                                    "Package Version",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("0.0.a.0"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Server Host",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Card(
                                child: ListTile(
                                  leading: Text(
                                    "Server Host",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Card(
                                    elevation: 0,
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("127.0.0.1:8000")),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Text(
                                      "Server Connection Status",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
    _blurAnimationController.dispose();
    super.dispose();
  }
}
