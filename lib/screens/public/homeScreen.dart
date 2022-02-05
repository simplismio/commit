import 'package:flutter/material.dart';
import 'package:start/screens/public/detailPage.dart';
import 'package:start/services/authenticationService.dart';
import 'package:start/services/localAuthenticationService.dart';
import 'package:start/services/themeService.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text('Home',
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
                  builder: (context) =>
                      Container(child: const Text('Show notifications')),
                );
              }),
          IconButton(
              icon: const Icon(
                Icons.add,
                size: 35.0,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) => const Text('New digital concept'),
                );
              }),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 5),
                child: Row(
                  children: <Widget>[
                    const Text(
                      "Just in",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: const Text(
                        "Sort by",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins-Bold',
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.sort),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    Get.to(const DetailPage());
                    //_lights = true;
                  });
                },
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: "",
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: const Text(
                      "This is my ListTile",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'A sufficiently long subtitle warrants .',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        Column(
                          children: [
                            const Icon(Icons.mobile_friendly),
                            const SizedBox(height: 5.0),
                            const Icon(Icons.mobile_friendly),
                          ],
                        ), // icon-1
                        Column(
                          children: [
                            const Icon(Icons.mobile_friendly),
                            const SizedBox(height: 5.0),
                            const Icon(Icons.mobile_friendly),
                          ],
                        ),

                        // icon-2
                      ],
                    ),
                    //isThreeLine: true,
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 30.0,
                      left: 90.0,
                      child: CircleAvatar(
                        radius: 50,
                        child: const Icon(Icons.person,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                    const Positioned(
                      child: const Text(
                        'Username',
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                          fontSize: 30,
                        ),
                      ),
                      top: 150,
                      left: 60,
                    ),
                  ],
                ),
              ),
              Consumer<ThemeService>(
                builder: (context, theme, child) => SwitchListTile(
                  title: const Text("Dark Mode"),
                  onChanged: (value) {
                    theme.toggleTheme();
                  },
                  value: theme.darkTheme,
                ),
              ),
              Consumer<LocalAuthenticationService>(
                builder: (context, localAuthentication, child) =>
                    SwitchListTile(
                  title: const Text("Biometric Unlock"),
                  onChanged: (value) {
                    localAuthentication.toggleBiometrics();
                  },
                  value: localAuthentication.biometrics,
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: GestureDetector(
                        child: const Text("Log Out", style: const TextStyle()),
                        onTap: () {
                          setState(() => loading = true);
                          AuthenticationService().signOut().then((result) {
                            Get.back();
                          });
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Container(
            child: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Sort',
                      style: const TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Sort',
                      style: const TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    ));
  }
}
