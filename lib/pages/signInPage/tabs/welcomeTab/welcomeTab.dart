import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

//providers
import 'package:wannasit_client/providers/googleSignInProvider/googleSignInProvider.dart';

class WelcomeTab extends StatelessWidget {
  const WelcomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    final GoogleSignInProvider googleSignInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: FlutterLogo(),
        ),
        title: const Text("Welcome"),
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
                      Text(
                        "Welcome",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        user.displayName!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.black38)
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.photoURL!),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await googleSignInProvider.googleLogout();
                              googleSignInProvider.isWelcome = true;
                              googleSignInProvider.update();
                            },
                            child: const Text("Logout"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              googleSignInProvider.isWelcome = true;
                              googleSignInProvider.update();
                            },
                            child: const Text("Continue"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
