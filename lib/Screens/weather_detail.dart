import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/weather_model.dart';

class WeatherDetail extends StatefulWidget {
  Weather weather;
  WeatherDetail({super.key, required this.weather});

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // flexibleSpace: Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     Image.asset(
        //       getBackgroundImage(widget.weather.time, widget.weather.condition),
        //       fit: BoxFit.cover,
        //     ),
        //   ],
        // ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getBackgroundImage(widget.weather.time, widget.weather.condition)),
            fit: BoxFit.cover,
          )
        ),
        child:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.weather.name, style: TextStyle(fontSize: 30),),
                      Text("${widget.weather.temperature} °", style: TextStyle(fontSize: 60),),
                      Text(getWeatherFrench(widget.weather.condition), style: TextStyle(fontSize: 15),),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.arrow_upward, size: 15,),
                          Text("${widget.weather.tempMax} °"),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_downward, size: 15,),
                          Text("${widget.weather.tempMin} °"),
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 100,),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 310,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text("Prevision pour les prochaines heures"),
                                Divider(
                                  height: 10,
                                  color: Colors.grey.shade300,
                                ),
                                Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.weather.previsions.length,
                                      itemBuilder: (BuildContext context, int index){
                                        final prevision = widget.weather.previsions[index];
                                        return Container(
                                          //color: Colors.pink,
                                          padding: EdgeInsets.all(10.0), // Ajoutez l'espacement souhaité ici
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(prevision['time'] ?? ''),
                                              SizedBox(height: 15.0), // Ajoutez un espace vertical
                                              Lottie.asset(
                                                  getWeatherAnimation("${prevision['cond']}" ?? '', prevision['moment'] ?? '' ),
                                                  height: 40,
                                                  width: 40
                                              ),
                                              SizedBox(height: 15.0), // Ajoutez un espace vertical
                                              Text("${prevision['temp']}  °"?? 'xx °'),
                                            ],
                                          ),
                                        );
                                      },)
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ressenti",),
                                Divider(
                                  height: 10,
                                  color: Colors.grey.shade300,
                                ),
                                Text("${widget.weather.feel} °", style: TextStyle(fontSize: 40),)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Humidite",),
                                Divider(
                                  height: 10,
                                  color: Colors.grey.shade300,
                                ),
                                Text("${widget.weather.humidity} %", style: TextStyle(fontSize: 40),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 170,
                          width: 310,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Opacity(
                            opacity: 0.7,
                            child: Image.asset('assets/images/sunrise1.PNG', fit: BoxFit.cover,),
                          ),

                        ),
                        Padding(
                          padding: EdgeInsets.all((15)),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Lever du soleil", style: TextStyle(fontSize: 15),),
                              Text("${widget.weather.sunrise} ", style: TextStyle(fontSize: 30),)
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 170,
                          width: 310,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Opacity(
                            opacity: 0.7,
                            child: Image.asset('assets/images/sunset1.2.jpg', fit: BoxFit.cover,),
                          ),

                        ),
                        Padding(
                          padding: EdgeInsets.all((15)),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Coucher du soleil", style: TextStyle(fontSize: 15),),
                              Text("${widget.weather.sunset} ", style: TextStyle(fontSize: 30),)
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      )
    );
  }
}
