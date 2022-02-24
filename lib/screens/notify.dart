import 'package:flutter/material.dart';
import 'package:tiktok/screens/home.dart';

class Notify extends StatefulWidget {
  const Notify({Key? key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            // passing this to our root
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        centerTitle: false,
        actions: <Widget>[
          TextButton(
            child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage())),
          ),
        ],
      ),
    );
  }
}
