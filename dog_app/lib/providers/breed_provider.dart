import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BreedProvider extends ChangeNotifier{

  final List<String> _dogBreeds = [];

  List <String> get dogBreeds {
    return [..._dogBreeds];
  }

  final List<String> _ranDog = [];

  List <String> get ranDog {
    return [..._ranDog];
  }

  late List<String> _dogPictures = [];

  List<String> get dogPictures {
    return [..._dogPictures];
  }

  Future<void> fetchDogBreedImages(String breed) async {
    final response = await http
        .get(Uri.parse('https://dog.ceo/api/breed/$breed/images'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<String> images = List<String>.from(data['message']);
        _dogPictures = images;
    } else {
      throw Exception('Failed to load breed images');
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

  Future<void> fetchRanDogPictureCall(String b) async  {
    try {
      String dogPicture = await fetchRanDogPicture(b);
      _ranDog.add(dogPicture);
    } catch (e) {
      // Handle error if necessary
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  Future<void> fetchDogBreeds() async {
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
          _dogBreeds.add(breed);
          fetchRanDogPictureCall(breed);
          notifyListeners();
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
}


