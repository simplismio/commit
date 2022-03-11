import 'package:commit/pages/public/home_screen.dart';
import '../../services/commitment_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<List<CommitmentService>>.value(
          value: CommitmentService().commitments,
          initialData: [],
          catchError: (BuildContext context, e) {
            if (kDebugMode) {
              print("Error:$e");
            }
            return [];
          }),
    ], child: const HomeScreen());
  }
}
