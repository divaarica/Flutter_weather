import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/model/cities_model.dart';

import '../model/listCities.dart';

class SelectedPage extends StatefulWidget {
  listCities lv;

  SelectedPage({super.key, required this.lv});

  @override
  State<SelectedPage> createState() => _SelectedPageState();
}

class _SelectedPageState extends State<SelectedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.lv.selectedCities.isEmpty
            ? const Center(child: Text("Aucune ville sellectionnee", style: TextStyle(fontSize: 20, ),),)
            : Column(
              children: [
                Text("Ville(s) selectionnee(s)", style: TextStyle(fontSize: 16,color: Colors.grey.shade600,),),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.lv.selectedCities.length,
                      itemBuilder: (context,index){
                        Cities v = widget.lv.selectedCities[index];
                        return CitieItem(v);
                      }),
                ),
              ],
            ),
      ),
    );
  }

  Widget CitieItem(Cities v){
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.location_on, color: Colors.white,),
      ),
      title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold),),
      trailing: const Icon(Icons.check_circle, color: Colors.blue,),
      onTap: (){
        setState(() {
          for( Cities vl in widget.lv.cities){
            if(v.name == vl.name){
              vl.isSelected = false;
            }
          }
          //v.isSelected = !widget.lv.villes[index].isSelected;
          widget.lv.selectedCities.removeWhere((element) => element.name == v.name);
        });
      },
    );
  }


}
