import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/Screens/weather_detail.dart';
import 'package:weather/model/weather_model.dart';

import '../controllers/weatherController.dart';

class WeatherPage extends StatefulWidget {
  List<String> cities;
  WeatherPage({super.key, required this.cities});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late final WeatherController weatherController;

  int _currentPage = 0;
  late bool finish;

  //Il faut initialise rpour simuler un clic
  @override
  void initState() {
    super.initState();
    weatherController = Get.put(WeatherController(widget.cities));
    weatherController.startProgressBar();
    weatherController.startTextMessage();
    weatherController.startWeatherUpdates();
    finish = false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[200],
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("R E S U L T A T S",),
        centerTitle: true,
        //backgroundColor: Colors.grey[200],
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Padding(
              padding: EdgeInsets.all(30.0),
              child: Container(
                height: 50,
                child: Text(
                  weatherController.displayTexts.value,
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                )),
              ),
            ),
            SizedBox(height: 15),
            Obx(
                () => Text('${(weatherController.progressValue.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                )
            ),
            Obx(() {
              final double progressValue = weatherController.progressValue.value;
              final bool progressComplete = progressValue >= 1.0;

              return progressComplete
                  ? ElevatedButton(
                  onPressed: (){
                    weatherController.progressValue.value = 0.0;
                    weatherController.weatherList.clear();
                    weatherController.currentIndex = 0;
                    weatherController.startProgressBar();
                    weatherController.startTextMessage();
                    weatherController.startWeatherUpdates();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
                    // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text("Recommencer", style: TextStyle(color: Colors.white),))
                  :  Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: LinearProgressIndicator(
                    value: weatherController.progressValue.value,
                    backgroundColor: Colors.lightBlueAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                    minHeight: 15.0,
                  ),
                ),
              );

            }
            ),
            const SizedBox(height: 50),
            Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: weatherController.weatherList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final weather = weatherController.weatherList[index];
                      return GestureDetector(
                        child: Container(
                          height: 120,
                          //color: Colors.deepPurpleAccent,
                          child: Card(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: AssetImage(getMomentImage(weather.moment)),
                                      fit: BoxFit.cover,
                                    )
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft, // Pour aligner à gauche
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text('${weather.name}', style: TextStyle(color: Colors.white)),
                                            subtitle: Text('${weather.time} ', style: TextStyle(color: Colors.white)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 12.0),
                                            child: Lottie.asset(
                                              getWeatherAnimation(weather.condition, weather.moment),
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight, // Pour aligner à droite
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [

                                          Padding(
                                             padding: EdgeInsets.only(right: 12.0, top:12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('${weather.temperature} °', style: TextStyle(color: Colors.white, fontSize: 40)),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Icon(Icons.arrow_upward, size: 15,color: Colors.white),
                                                    Text("${weather.tempMax} °", style: TextStyle(fontSize: 15, color: Colors.white,),),
                                                    SizedBox(width: 10,),
                                                    Icon(Icons.arrow_downward, size: 15, color: Colors.white),
                                                    Text("${weather.tempMin} °", style: TextStyle(fontSize: 15, color: Colors.white,),),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        onTap: (){
                          Get.to(WeatherDetail(weather: weather));
                        },
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }



  String getMomentImage(String moment){
    //print(moment);
    if (moment.toLowerCase() == 'matin'){
      return 'assets/images/day.jpg';

    }
    return 'assets/images/nuit.jpg';
  }
}
