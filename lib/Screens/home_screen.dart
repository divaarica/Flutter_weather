import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/Screens/tabBar_screen.dart';

import '../controllers/themeController.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ThemeController _themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
              children:[
                Obx(() => Switch(
                  value: _themeController.isDarkMode.value,
                  onChanged: (value) {
                    _themeController.changeTheme();
                    final ThemeData themeData = Theme.of(context);
                    SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle(
                        systemNavigationBarColor: _themeController.themeData.value.colorScheme.background,
                      ),
                    );
                  },
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.blue.shade200, // Couleur
                )),
              ]
          ),
          const SizedBox(height: 70,),
          const Text("Bienvenue", style: TextStyle(fontSize: 30,),),
          //animation lottie
          Lottie.asset('assets/lottie/acceuil.json',
            fit: BoxFit.cover,
          ),
          ElevatedButton(
            onPressed:(){
              Get.to(basePage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade200, // Couleur de fond du bouton
              elevation: 10, // Élévation du bouton
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(8), // Bord arrondi
              //   side: BorderSide(color: Colors.white, width: 2), // Bordure blanche
              // ),
              shadowColor: Colors.black, // Couleur de l'ombre
            ),
            // style: ButtonStyle(
            //   elevation: MaterialStateProperty.all<double>(8), // Augmentation de la taille de l'ombre
            //   shadowColor: MaterialStateProperty.all<Color>(Colors.white), // Couleur de l'ombre
            // ),
            child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Commencer', style: TextStyle(color: Colors.black38, fontSize: 16),)),
          )
        ],
      ),
    );
  }
}


