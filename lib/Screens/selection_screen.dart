import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:weather/Screens/weather_screen.dart';
import 'package:weather/model/cities_model.dart';

import '../model/listCities.dart';

class SelectionPage extends StatefulWidget {
  listCities lv;

  SelectionPage({super.key, required this.lv});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Toutes les Villes", style: TextStyle(fontSize: 16,color: Colors.grey.shade600),),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.lv.cities.length,
                  itemBuilder: (context,index){
                    Cities v = widget.lv.cities[index];
                    return CitieItem(v.name, v.isSelected, index);
                  }),
            ),
            widget.lv.selectedCities.length > 4 ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10,),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: (){
                  List<String> villes = [];
                  for(Cities vl in widget.lv.selectedCities){
                    villes.add(vl.name);
                  }
                  Get.to(WeatherPage(cities: villes));
                },
                child: const Text("Continuer", style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
            ) : Container(),
          ],
        ),
      ),


    );
  }

  Widget CitieItem(String name, bool isSelected, int index){
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.location_on, color: Colors.white,),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold),),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue,)
          : const Icon(Icons.check_circle_outline, color: Colors.grey,),
      onTap: (){
        setState(() {
          if(widget.lv.selectedCities.length<5){
            widget.lv.cities[index].isSelected = !widget.lv.cities[index].isSelected;
            if(widget.lv.cities[index].isSelected){
              widget.lv.selectedCities.add(Cities(name: name, isSelected: isSelected));
            }else{
              widget.lv.selectedCities.removeWhere((element) => element.name == widget.lv.cities[index].name);
            }
          }else{
            //si la ville est a true et qu'on clique alors on la remove de la liste
            if(widget.lv.cities[index].isSelected){
              widget.lv.cities[index].isSelected = !widget.lv.cities[index].isSelected;
              widget.lv.selectedCities.removeWhere((element) => element.name == widget.lv.cities[index].name);
            }
          }

        });
      },
    );
  }

}
