import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

//providers
import 'package:wannasit_client/providers/googleSignInProvider/googleSignInProvider.dart';
import 'package:wannasit_client/providers/signInColorSchemeProvider/signInColorSchemeProvider.dart';
import 'package:wannasit_client/providers/homePageColorSchemeProvider/homePageColorSchemeProvider.dart';

//pages
import 'package:wannasit_client/pages/signInPage/signInPage.dart';
import 'package:wannasit_client/pages/homePage/homePage.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCxTa7DLX3NFegt2BW5GOb9ZBXl2hsIavg",
              authDomain: "wannas-5e2c4.firebaseapp.com",
              projectId: "wannas-5e2c4",
              storageBucket: "wannas-5e2c4.appspot.com",
              messagingSenderId: "358207789317",
              appId: "1:358207789317:web:da2cbb34de3427ec273f6c",
              measurementId: "G-EWET20HGWC")),
      builder: (context, firebaseInitSnapshot) {
        if (firebaseInitSnapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => GoogleSignInProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SignInColorSchemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => HomePageColorSchemeProvider(),
              ),
            ],
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    Provider.of<GoogleSignInProvider>(context).isWelcome) {
                  final HomePageColorSchemeProvider
                      homePageColorSchemeProvider =
                      Provider.of<HomePageColorSchemeProvider>(context);
                  return MaterialApp(
                    title: "Wannasit",
                    home: const HomePage(),
                    theme: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.light,
                      colorSchemeSeed: homePageColorSchemeProvider.colorScheme,
                      textTheme: TextTheme(
                        titleLarge: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        bodyLarge: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      appBarTheme: AppBarTheme(
                        color: Theme.of(context).secondaryHeaderColor,
                        titleSpacing: 5,
                        centerTitle: false,
                      ),
                    ),
                    darkTheme: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.dark,
                      colorSchemeSeed: homePageColorSchemeProvider.colorScheme,
                      textTheme: TextTheme(
                        titleLarge: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        bodyLarge: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      appBarTheme: AppBarTheme(
                        color: Theme.of(context).primaryColorDark,
                        titleSpacing: 5,
                        centerTitle: false,
                      ),
                    ),
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
                        titleLarge: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        bodyLarge: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      appBarTheme: AppBarTheme(
                        color: Theme.of(context).secondaryHeaderColor,
                        titleSpacing: 5,
                        centerTitle: false,
                      ),
                    ),
                    darkTheme: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.dark,
                      colorSchemeSeed: signInColorSchemeProvider.colorScheme,
                      textTheme: TextTheme(
                        titleLarge: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        bodyLarge: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      appBarTheme: AppBarTheme(
                        color: Theme.of(context).primaryColorDark,
                        titleSpacing: 5,
                        centerTitle: false,
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
