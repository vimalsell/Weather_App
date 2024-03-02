import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forecast_items.dart';
import 'package:weather_app/additional_info_items.dart';
import 'package:weather_app/secrets.dart';
import 'package:http/http.dart' as http;
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String,dynamic>> getCurrentWeather ()async{
    try{
      final cityName ='london';
      final res = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openweatherApiKeys'));
      final data = jsonDecode(res.body);
      if(data['cod'] != '200'){
        throw 'An unexpected error occurs';
      }
      return data;
    } catch(e){
      throw e.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    final border =OutlineInputBorder(borderSide: BorderSide(
      color: Color.fromRGBO(225, 225, 225, 1),),
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)));
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Weather App',
          style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        ),
        actions:[IconButton(onPressed: (){ setState(() {});}, icon:Icon(Icons.refresh_rounded))] ,
      ),
      body:SingleChildScrollView(
        child: FutureBuilder(
          future: getCurrentWeather(),
          builder:(context,Snapshot) {
            if(Snapshot.connectionState==ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator.adaptive() ,);
            }
            final data = Snapshot.data!;
            final currentTemp = data['list'][0]['main']['temp'];
            final currentSky = data['list'][0]['weather'][0]['main'];
            final currentPressure = data['list'][0]['main']['pressure'];
            final currentHumidity = data['list'][0]['main']['humidity'];
            final currentSpeed = data['list'][0]['wind']['speed'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text('$currentTemp K', style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32),),
                                SizedBox(height: 16,),
                                Icon(currentSky =='Clouds'||currentSky=='Rain'? Icons.cloud : Icons.sunny, size: 64,),
                                SizedBox(height: 16,),
                                Text('$currentSky', style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text('Weather ForeCast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 8,),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context,index){
                        final hourlyForecast = data['list'][index+1];
                        final hourlySky = data['list'][index+1]['weather'][0]['main'];
                        final hourlyTemp = hourlyForecast['main']['temp'].toString();
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForecastItem(time:DateFormat.Hm().format(time), icon: hourlySky=='Clouds' || hourlySky=='Rain'? Icons.cloud : Icons.sunny, temp: hourlyTemp);
                      } ),
                  ),
                  SizedBox(height: 20,),
                  Text('Additional Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoItems(
                          icon: Icons.water_drop,
                          label: 'Humidityy',
                          value: '$currentHumidity',
                        ),
                        AdditionalInfoItems(
                          icon: Icons.air,
                          label: 'Wind Speed',
                          value: '$currentSpeed',
                        ),
                        AdditionalInfoItems(
                          icon: Icons.beach_access,
                          label: 'Pressure',
                          value: '$currentPressure',
                        )
                      ]
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}


