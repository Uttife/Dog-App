import 'package:dog_app/providers/breed_provider.dart';
import 'package:dog_app/providers/connectivity_status.dart';
import 'package:dog_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (BuildContext context) => ConnectivityStatus()),
            ChangeNotifierProvider(create: (BuildContext context) => BreedProvider()),
          ],
        child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DogBreedsScreen()
    );
  }
}
