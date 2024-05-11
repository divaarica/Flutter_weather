import 'dart:async';

import 'package:get/get_connect/connect.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/weather_model.dart';

class WeatherController extends GetxController{
  //final CarouselController carouselController = CarouselController();
  RxList<Weather> weatherList = <Weather>[].obs; //la liste des meteos des villes qui est dynamique
  RxDouble progressValue = 0.0.obs; //valeur de la progression
  RxString displayTexts = ''.obs;
  Timer? _progressTimer ;
  Timer? _messageTimer;
  Timer? _weatherTimer;
  int currentIndex=0; //va servir pour savoir sur quel ville on est actuelle , la position dans le tableau
  List<String> cities;
  bool end = false;

  //on initialise les villes choisies
  WeatherController(this.cities);


  // methode pour commencer la progression
  void startProgressBar(){
    const oneSec = const Duration(seconds: 1);
    _progressTimer = Timer.periodic(oneSec, (timer) {
      if(progressValue<1){
        progressValue.value += 1/60 ;
      }else{
        _progressTimer?.cancel();
        _messageTimer?.cancel();
        _weatherTimer?.cancel();
        displayTexts.value = 'Progession Terminee !';
        end = true;

      }

    });

  }

  //methode pour commenecer l'affichage des messages
  void startTextMessage(){
    const messages = [
      'Nous telechargons les donnes ...',
      'C \'est presque fini ...',
      'Plus que quelques secondes avant d\'avoir le resultat ...',
    ];

    int index = 0;
    const sixSec = const Duration(seconds: 6);
    _messageTimer = Timer.periodic(sixSec, (timer) {
      if (progressValue.value < 1) {
        displayTexts.value = messages[index];
        index++;
        if (index >= messages.length) {
          index = 0; // Réinitialiser l'index à zéro pour recommencer le cycle de messages
        }
      } else {
        _messageTimer?.cancel(); // Arrêter le timer lorsque la progression est terminée
      }
    });

  }

  //pour l'affichage des villes et leur meteo
  void startWeatherUpdates(){
    // pour commenecer 15 seconde apres le debut
    //Cela signifie que le code à l'intérieur des accolades sera exécuté 15 secondes après l'appel de startWeatherUpdates.
    const fiftyMinutes = const Duration(seconds: 15);
    Future.delayed(fiftyMinutes, ()
    {
      //apres les 15 secondes il recuperes la meteo de la premiere ville
      fetchWeatherData();

      //ensuite il affiche la meteo des autres villes toutes les 10 secondes
      const tenSec = const Duration(seconds: 10);
      _weatherTimer = Timer.periodic(tenSec, (timer) {
        fetchWeatherData();
      });
    });
  }


  Future<void> fetchWeatherData() async{
    //final cities = ['Paris', 'Rennes', 'Marseille', 'Dijon', 'Rouen'];
    final city = cities[currentIndex];
    const apiKey = '';

    //avec http
    // final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));
    //
    // if(response.statusCode == 200){
    //   final decodeData = jsonDecode(response.body);
    //   final temperature = decodeData['main']['temp'];
    //   weatherList.add(Weather(name: city, temperature: temperature));
    // }

    //avec getX
    final response = await GetConnect().get(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    if (response.statusCode == 200) {
      final temperature = response.body['main']['temp'].toInt().toString();
      final condition = response.body['weather'][0]['main'];
      final tempMax = response.body['main']['temp_max'].toInt().toString();
      final tempMin = response.body['main']['temp_min'].toInt().toString();
      final feel = response.body['main']['feels_like'].toInt().toString();
      final humidity = response.body['main']['humidity'].toInt().toString();
      int timezoneOffset = response.body['timezone'];
      final sunrise = formatTimestamp(response.body['sys']['sunrise'], timezoneOffset);
      final sunset = formatTimestamp(response.body['sys']['sunset'], timezoneOffset);
      //var timestamp = response.body['dt'];

      // Extract timezone offset


      // Calculate the current time in Seoul
      DateTime currentTime = DateTime.now().add(Duration(seconds: timezoneOffset));
      String time = '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';


      //convertir timesstamp en dateTime
      //var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);// car 1sec = 1000 milisec

      // var morningStart = DateTime(currentTime.year, currentTime.month, currentTime.day, 6);
      // var eveningStart = DateTime(currentTime.year, currentTime.month, currentTime.day, 18);
      //
      // if((currentTime.isAfter(morningStart)  || currentTime.isAtSameMomentAs(morningStart)) && dateTime.isBefore(eveningStart)){
      //   weatherList.add(Weather(name: city, temperature: temperature.toString(), condition: condition, moment: "Matin"));
      // }else{
      //   weatherList.add(Weather(name: city, temperature: temperature.toString(), condition: condition, moment: "Soir"));
      // }
      DateTime srTime = DateTime.fromMillisecondsSinceEpoch(response.body['sys']['sunrise']* 1000);
      DateTime snTime = DateTime.fromMillisecondsSinceEpoch(response.body['sys']['sunset']*1000);

      srTime = srTime.add(Duration(seconds: timezoneOffset));
      snTime = snTime.add(Duration(seconds: timezoneOffset));

      //print(city);
      // Déterminer si c'est le matin ou le soir
      print(city);
      print(srTime);
      print(snTime);
      String moment = (currentTime.isAfter(srTime) || currentTime.isAtSameMomentAs(srTime)) && currentTime.isBefore(snTime) ? 'Matin' : 'Soir';
      List<Map<String, String>> previsions = await getForecast(city, apiKey, timezoneOffset, time, temperature.toString(), condition, moment);

      weatherList.add(Weather(
          name: city,
          temperature: temperature,
          condition: condition,
          moment: moment,
          tempMax: tempMax,
          tempMin: tempMin,
          feel: feel,
          humidity: humidity,
          sunrise: sunrise,
          sunset: sunset,
          previsions: previsions,
          time: time,
      ));

          }
    //carouselController.animateToPage(currentIndex);
    currentIndex ++;
    if(currentIndex >= cities.length){
      currentIndex = 0;
    }


  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    _messageTimer?.cancel();
    _weatherTimer?.cancel();
    super.onClose();
  }

  /*La méthode onClose() est une autre méthode du cycle de vie des contrôleurs GetX.
  Elle est appelée automatiquement lorsqu'un contrôleur est supprimé de la mémoire
  Cette méthode est principalement utilisée pour effectuer des opérations de nettoyage ou de libération de ressources lorsque le contrôleur n'est plus nécessaire

  Ici cette methode est utilisée pour annuler tous les timers (_progressTimer, _messageTimer et _weatherTimer)
  afin de s'assurer qu'ils ne continuent pas à s'exécuter en arrière-plan une fois que le contrôleur est fermé.*/


//La méthode onInit() est une méthode du cycle de vie des contrôleurs GetX.
// Elle est appelée automatiquement lors de l'initialisation du contrôleur, c'est-à-dire lorsque le contrôleur est créé pour la première fois.
//est utilisée pour effectuer des initialisations nécessaires au démarrage du contrôleur,
//telles que la configuration initiale, l'initialisation des observables, l'abonnement aux streams, etc.
// @override
// void onInit() {
//   super.onInit();
// }

// void startWeatherUpdates() {
//   // Démarrer le timer principal
//   const oneMinute = const Duration(minutes: 1);
//   _weatherTimer = Timer(oneMinute, () {
//     // Après une minute, démarrer le timer de récupération de données
//     const tenSec = const Duration(seconds: 10);
//     _weatherTimer = Timer.periodic(tenSec, (timer) {
//       fetchWeatherData();
//     });
//   });
// }

}
