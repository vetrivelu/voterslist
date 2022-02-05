import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voterslist/auth/auth.dart';
import 'package:voterslist/auth/login.dart';

import 'list.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  final auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: Auth().authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user != null) {
              return VotersList(auth: auth);
            } else {
              return LoginPage(auth: auth);
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
