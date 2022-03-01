// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:commit/screens/public/homeScreen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailPage extends StatefulWidget {
  final description;
  const DetailPage({Key? key, this.description}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.chevron_left,
              ),
              onPressed: () {
                Get.to(const HomeScreen());
              },
            );
          },
        ),
        title: const Text('Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins-Bold',
            )),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.notifications,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) => const Text('Show notifications'),
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(widget.description),
      ),
    );
  }
}
