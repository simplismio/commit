import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:commit/screens/public/homeScreen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

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
                color: Colors.black,
              ),
              onPressed: () {
                Get.to(const HomeScreen());
              },
            );
          },
        ),
        title: const Text('Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins-Bold',
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) =>
                      Container(child: Text('Show notifications')),
                );
              }),
          IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 35.0,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) =>
                      Container(child: Text('New digital concept')),
                );
              }),
        ],
      ),
      body: Container(
        child: const Text('Yahoo!'),
      ),
    );
  }
}
