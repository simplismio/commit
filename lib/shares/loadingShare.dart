// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingShare extends StatelessWidget {
  const LoadingShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Padding(padding: EdgeInsets.only(top: 15.0)),
            Text(
              "Commit",
              style: TextStyle(fontSize: 25.0, color: Colors.grey),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            SpinKitFadingFour(
              color: Colors.grey,
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
