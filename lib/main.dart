import 'package:flutter/material.dart';
import 'package:flutter_firebase/firestore_islemleri.dart';
import 'package:flutter_firebase/login_islemleri.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Firebase Demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirestoreIslemleri(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
