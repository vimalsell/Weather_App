import 'package:flutter/material.dart';
import 'package:weather_app/providername.dart';
import 'package:weather_app/weather_screen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(create: (context)=>ProviderName(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home:  WeatherScreen(),
      ),
    );
  }
}
