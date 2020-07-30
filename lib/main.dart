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
      home: MyHomePage(),
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(color: Colors.deepOrange,
                child: Text("Firestore İşlemlerine Git",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FirestoreIslemleri())),
              ),
              RaisedButton(color: Colors.lightBlue,
                child: Text("Firebase İşlemlerine Git",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginIslemleri())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
