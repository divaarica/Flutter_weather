import 'package:get/get_connect/connect.dart';

class Weather{
  final String name;
  final String temperature;
  final String condition;
  final String moment;
  final String tempMax;
  final String tempMin;
  final String feel;
  final String humidity;
  final String sunrise;
  final String sunset;
  final String time;
  final List<Map<String, String>> previsions;

  Weather({
    required this.name,
    required this.temperature,
    required this.condition,
    required this.moment,
    required this.tempMax,
    required this.tempMin,
    required this.feel,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
    required this.previsions,
    required this.time,
  });

}

String formatTimestamp(int timestamp, int timezone) {
  DateTime datetime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  datetime = datetime.add(Duration(seconds: timezone));
  String date = "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
  return date;
}


Future<List<Map<String, String>>> getForecast(String city, String apiKey, int timezoneOffset, String timeNow, String tempNow, String conditionNow, moment) async {
  List<Map<String, String>> previsions = [];
  previsions.add({
    'time': 'Maint',
    'temp': tempNow,
    'cond': conditionNow,
    'moment': moment,
  });

  final response = await GetConnect().get(
      'http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric');

  if(response.statusCode == 200){
    final List<dynamic> forecasts = response.body['list'];

    for(int i=0; i<20 && i<forecasts.length; i++){
      int timestamp = forecasts[i]['dt'];
      DateTime datetime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      DateTime currentTime = datetime.add(Duration(seconds: timezoneOffset));
      String date = "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}";
      String temp = forecasts[i]['main']['temp'].toInt().toString();
      final condition = forecasts[i]['weather'][0]['main'];
      String m = currentTime.hour >= 6 && currentTime.hour < 19 ? 'Matin' : 'Soir';
      previsions.add({
        'time': date,
        'temp': temp,
        'cond': condition,
        'moment': m,
      });

    }
    //ce foreach est utiliser pour les list dynamic
    // forecasts.forEach((forecast) {
    //   int timestamp = forecast['dt'];
    //   DateTime datetime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    //   DateTime currentTime = datetime.add(Duration(seconds: timezoneOffset));
    //   String date = "${currentTime.hour}:${currentTime.minute}";
    //   String temp = forecast['main']['temp'].toString();
    //   final condition = response.body['weather'][0]['main'];
    //
    //   previsions.add({
    //     'date': date,
    //     'temp': temp,
    //     'cond': condition,
    //   });
    //
    // });

  }

  // previsions.forEach((forecast) {
  //   print('time: ${forecast['time']}');
  //   print('Temperature: ${forecast['temp']}');
  //   print('Condition: ${forecast['cond']}');
  //   print('-------------------------');
  // });

  return previsions;

}

String getWeatherAnimation(String ? mainCondition, String moment){

  if(mainCondition != null){
    switch ( mainCondition.toLowerCase()){
      case 'clouds' :
        return 'assets/lottie/cloud.json';
      case 'mist' :
        return 'assets/lottie/vent.json';
      case 'haze' :
        return 'assets/lottie/vent.json';
      case 'smoke' :
        return 'assets/lottie/vent.json';
      case 'dust' :
        return 'assets/lottie/vent.json';
      case 'fog' :
        return 'assets/lottie/vent.json';
      case 'rain' :
        return 'assets/lottie/rain.json';
      case 'drizzle' :
        return 'assets/lottie/rain.json';
      case 'shower rain' :
        return 'assets/lottie/rain.json';
      case 'thunderstorm' :
        return 'assets/lottie/cloudEclairRain.json';
      case 'clear' :
        if(moment.toLowerCase() == "matin"){
          return 'assets/lottie/sun.json';
        }else{
          return 'assets/lottie/moon.json';
        }
      default:
        if(moment.toLowerCase() == "matin"){
          return 'assets/lottie/cloud.json';
        }else{
          return 'assets/lottie/moon.json';
        }
    }

  }

  if(moment.toLowerCase() == "matin"){
    return 'assets/lottie/sun.json';
  }else{
    return 'assets/lottie/moon.json';
  }

}
String getWeatherFrench(String ? mainCondition){

  if(mainCondition != null){
    switch ( mainCondition.toLowerCase()){
      case 'clouds' :
        return 'Nuageux';
      case 'mist' :
        return 'Brumeux';
      case 'haze' :
        return 'Brumeux';
      case 'smoke' :
        return 'Brumeux';
      case 'dust' :
        return 'Poussiereux';
      case 'fog' :
        return 'Brouillardeux';
      case 'rain' :
        return 'Pluvieux';
      case 'drizzle' :
        return 'Bruineux';
      case 'shower rain' :
        return 'Tres Pluvieux';
      case 'thunderstorm' :
        return 'Orageux';
      case 'clear' :
        return 'Clair';
      default:
        return 'Clair';
    }

  }

  return 'Clair';

}