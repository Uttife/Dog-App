import 'dart:async';
import 'package:dog_app/providers/breed_provider.dart';
import 'package:dog_app/providers/connectivity_status.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../widgets/dog_card.dart';

class DogBreedsScreen extends StatefulWidget {
  const DogBreedsScreen({super.key});

  @override
  _DogBreedsScreenState createState() => _DogBreedsScreenState();
}

class _DogBreedsScreenState extends State<DogBreedsScreen> {


  @override
  void initState() {
    super.initState();

    //fetch dog bread info
    Future.delayed(
      Duration.zero, () {
      final breedProvider = Provider.of<BreedProvider>(context, listen: false);
      final internetProvider = Provider.of<ConnectivityStatus>(context, listen: false);
      internetProvider.checkConnectivity();
      breedProvider.fetchDogBreeds();
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    final breedProvider = Provider.of<BreedProvider>(context);
    final internetProvider = Provider.of<ConnectivityStatus>(context);
    return
    //check if internet is availabe
      internetProvider.isOnline
      ? Scaffold(
        appBar: AppBar(
          title: const Text('Dog Breeds'),
          backgroundColor: Colors.blue[900],
        ),
        body:
        (breedProvider.dogBreeds.isEmpty) || (breedProvider.dogBreeds.isEmpty)
        ? const Center(
          child: CircularProgressIndicator(backgroundColor: Colors.black,
          color: Colors.blue,
          strokeWidth: 10),
        )
        : GridView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: breedProvider.ranDog.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 5 / 3,
          ),
          itemBuilder: (context, index) {
            return DogCard(breed: breedProvider.dogBreeds[index], image: breedProvider.ranDog[index]);
          },
        ))
      :  const Scaffold(
        body: Center(
          child: AlertDialog(
            title: Text('No Internet'),
            content: Text('Please connect to the Internet'),
          ),
        ),
      );
  }
}




