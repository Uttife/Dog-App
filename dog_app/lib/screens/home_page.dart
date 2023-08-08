import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../dog_card.dart';

class DogBreedsScreen extends StatefulWidget {
  const DogBreedsScreen({super.key});

  @override
  _DogBreedsScreenState createState() => _DogBreedsScreenState();
}

class _DogBreedsScreenState extends State<DogBreedsScreen> {

  List<String> dogBreeds = [];

  List<String> ranDog = [];

  Future<void> fetchDogBreeds() async {
    // const apiKey = 'live_syNxS5wY6C0PWtHNY2Z0UJntFi2UTfTSRl1tc8ZQnzubhPG8BHKJPERt03ZP4AWN'; // Replace this with your actual API key
    const url = 'https://dog.ceo/api/breeds/list/all';

    try {
      // Make the GET request
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Access the dog breeds data
        Map<String, dynamic> breeds = data['message'];

        // Print the list of all dog breeds
        for (var breed in breeds.keys) {
          dogBreeds.add(breed);
          fetchRanDogPictureCall(breed);
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during API request: $e');
      }
    }
  }

  Future<String> fetchRanDogPicture(String breed) async {
    final response = await http
        .get(Uri.parse('https://dog.ceo/api/breed/$breed/images/random'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String dogPicture = data['message'];
      return dogPicture;


    } else {
      throw Exception('Failed to load dog pictures');
    }
  }

  Future<void> fetchRanDogPictureCall(String b) async {
    try {
      String dogPicture = await fetchRanDogPicture(b);

      setState(() {
        ranDog.add(dogPicture);
      });
    } catch (e) {
      // Handle error if necessary
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDogBreeds();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dog Breeds'),
          backgroundColor: Colors.blue[900],
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: ranDog.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            return DogCard(breed: dogBreeds[index], image: ranDog[index]);
          },
        ));
  }
}




