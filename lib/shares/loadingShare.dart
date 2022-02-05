import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 15.0)),
            Text(
              "Start",
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
  //   return Container(
  //     color: Colors.grey[200],
  //     child: Center(
  //       child: SpinKitThreeBounce(
  //         color: Colors.black,
  //         size: 50.0,
  //       ),
  //     ),
  //   );
  // }
}
