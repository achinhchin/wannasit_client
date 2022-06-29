import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import 'package:wannasit_client/providers/googleSignInProvider/googleSignInProvider.dart';
import 'package:wannasit_client/providers/signInColorSchemeProvider/signInColorSchemeProvider.dart';

class SignInTab extends StatefulWidget {
  const SignInTab({super.key});

  @override
  State<SignInTab> createState() => _SignInTabState();
}

class _SignInTabState extends State<SignInTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _blurAnimationController;
  late CurvedAnimation _blurCurvedAnimation;
  late Animation<double> _blurAnimation;
  late Animation<Color?> _colorAnimtaion;

  @override
  void initState() {
    super.initState();
    _blurAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _blurCurvedAnimation = CurvedAnimation(
        curve: Curves.easeOut, parent: _blurAnimationController);
    _blurAnimation = Tween<double>(
      begin: 0,
      end: 7.5,
    ).animate(_blurCurvedAnimation);
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
            title: const Text("Sign In"),
          ),
          body: LayoutBuilder(
            builder: (context, bodyConstraints) {
              return Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: bodyConstraints.maxHeight),
                    child: Center(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: FlutterLogo(
                              size: 100,
                            ),
                          ),
                          Text(
                            "Wannasit",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(
                            height: bodyConstraints.maxHeight * .2,
                          ),
                          const Text("Sign in with @samsenwit.ac.th mail"),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final GoogleSignInProvider
                                    googleSignInProvider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                final SignInColorSchemeProvider
                                    signInColorSchemeProvider =
                                    Provider.of<SignInColorSchemeProvider>(
                                        context,
                                        listen: false);
                                () async {
                                  _blurAnimationController.value = 0;
                                  await _blurAnimationController.forward();

                                  try {
                                    await googleSignInProvider.googleLogin();
                                  } catch (error) {
                                    if (error == "notsamsenmail") {
                                      signInColorSchemeProvider.setColorScheme =
                                          Colors.red;
                                      await showMyDiaglog(
                                        child: AlertDialog(
                                          title: const Text(
                                            "Wrong Mail",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                              "You have to use @samsenwit.ac.th mail to sign in."),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Ok"),
                                            )
                                          ],
                                        ),
                                      );
                                      signInColorSchemeProvider.setColorScheme =
                                          signInColorSchemeProvider
                                              .defaultColorScheme;
                                    } else {
                                      signInColorSchemeProvider.setColorScheme =
                                          Colors.red;
                                      await showMyDiaglog(
                                        child: AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text(
                                              ":(\nSomething went wrong!\nPlease try again."),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Ok"),
                                            )
                                          ],
                                        ),
                                      );
                                      signInColorSchemeProvider.setColorScheme =
                                          signInColorSchemeProvider
                                              .defaultColorScheme;
                                    }
                                  }

                                  _blurAnimationController.value = 1;
                                  await _blurAnimationController.reverse();

                                  googleSignInProvider.update();
                                }();
                              },
                              label: const Text("Sign In with google"),
                              icon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7.5),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset("assets/icons/google.png"),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _blurAnimationController,
          builder: (BuildContext context, Widget? child) => Visibility(
            visible: _blurAnimationController.value > 0,
            child: Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: _colorAnimtaion.value,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> showMyDiaglog({required Widget child}) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        barrierDismissible: false,
        opaque: false,
        barrierColor: Colors.black26,
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
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
      ),
    );
  }

  @override
  void dispose() {
    _blurAnimationController.dispose();
    super.dispose();
  }
}
