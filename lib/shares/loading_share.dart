import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingShare extends StatelessWidget {
  const LoadingShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        SpinKitFadingFour(
          color: Colors.grey,
          size: 50.0,
        )
      ],
    );
  }
}
