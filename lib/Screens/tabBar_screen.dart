import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/Screens/selected_screen.dart';
import 'package:weather/Screens/selection_screen.dart';
import 'package:weather/model/listCities.dart';

import '../controllers/themeController.dart';

class basePage extends StatefulWidget {
  const basePage({super.key});

  @override
  State<basePage> createState() => _basePageState();
}

class _basePageState extends State<basePage> {

  listCities lv = listCities();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            //backgroundColor: Colors.grey[200],
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: const Text("V I L L E S",
                style: TextStyle(color: Colors.blue),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            body: Column(
              children: [
                const TabBar(
                  //indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.blue,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.list,
                        color: Colors.grey,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SelectionPage(lv: lv),
                      SelectedPage(lv: lv),
                    ],
                  ),
                ),
              ],
            )
          // bottomNavigationBar: MyBottomNavBar(
          //   // onTabChange: (index) => navigationBottomBar(index),
          //   onTabChange: navigationBottomBar,
          // ),
        ),
    );
  }
}
