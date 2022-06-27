import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

//providers
import 'package:wannasit_client/providers/googleSignInProvider/googleSignInProvider.dart';
import 'package:wannasit_client/providers/signInColorSchemeProvider/signInColorSchemeProvider.dart';

//pages
import './pages/signInPage/signInPage.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, firebaseInitSnapshot) {
        if (firebaseInitSnapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => GoogleSignInProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SignInColorSchemeProvider(),
              )
            ],
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (false) {
                  return const MaterialApp(
                    home: Text("test"),
                  );
                } else {
                  final SignInColorSchemeProvider signInColorSchemeProvider =
                      Provider.of<SignInColorSchemeProvider>(context);
                  return MaterialApp(
                    title: "Wannasit",
                    theme: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.light,
                      colorSchemeSeed: signInColorSchemeProvider.colorScheme,
                      textTheme: TextTheme(
                        titleLarge:
                            const TextStyle(fontWeight: FontWeight.bold),
                        bodyLarge: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    darkTheme: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.dark,
                      colorSchemeSeed: signInColorSchemeProvider.colorScheme,
                      textTheme: TextTheme(
                        titleLarge:
                            const TextStyle(fontWeight: FontWeight.bold),
                        bodyLarge: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    home: const SignInPage(),
                  );
                }
              },
            ),
          );
        } else {
          return MaterialApp(
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: Scaffold(
              appBar: AppBar(
                leading: const Padding(
                  padding: EdgeInsets.all(10),
                  child: FlutterLogo(),
                ),
                titleSpacing: 5,
                centerTitle: false,
                title: const Text(
                  "Start Firebase",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
