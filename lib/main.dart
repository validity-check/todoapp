import 'package:flutter/material.dart';
import 'package:todoapp/screens/home.dart';

// Services
import 'package:todoapp/services/auth.dart';

// Widgets
import 'package:todoapp/widgets/loading.dart';

// Screens
import 'package:todoapp/screens/login.dart';

// Import the firebase stuffs
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FutureBuilder(

          // Initialize FlutterFire:

          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors

            if (snapshot.hasError) {
              return const Scaffold(body: Center(child: Text("ERROR!")));
            }

            // Once complete, show your application

            if (snapshot.connectionState == ConnectionState.done) {
              return Root();
            }

            // Otherwise, show loading screnn

            return loadingScreen;
          }),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth(auth: _auth).user, // Auth stream
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            // Login screen
            return Login(auth: _auth, firestore: _firestore);
          } else {
            // Home screen
            return Home(auth: _auth, firestore: _firestore);
          }
        } else {
          // Loading screen
          return loadingScreen;
        }
      },
    );
  }
}
