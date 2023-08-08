import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BreedInfo extends StatefulWidget {
  final String breed;

  const BreedInfo({Key? key, required this.breed}) : super(key: key);

  @override
  State<BreedInfo> createState() => _BreedInfoState();
}

class _BreedInfoState extends State<BreedInfo> {

  late CarouselController _pageController;

  int pageIndex = 0;

  List<String> _dogPictures = [];

  Future<void> fetchDogBreedImages() async {
    final response = await http
        .get(Uri.parse('https://dog.ceo/api/breed/${widget.breed}/images'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<String> images = List<String>.from(data['message']);
      setState(() {
        _dogPictures = images;
      });
    } else {
      throw Exception('Failed to load breed images');
    }
  }

  void _nextSlide() {
    _pageController.nextPage();
  }

  void _previousSlide() {
    _pageController.previousPage();
  }

  @override
  void initState() {
    super.initState();
    _pageController = CarouselController();
    fetchDogBreedImages();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.breed.toUpperCase()),
          backgroundColor: Colors.black),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                        color: Colors.white38,
                        border: Border(
                          left: BorderSide(color: Colors.blue, width: 8),
                        )),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Expanded(
                        child: CarouselSlider.builder(
                          itemCount: _dogPictures.length,
                          itemBuilder: (context, index, realIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      child: Image.network(
                                        _dogPictures[index],
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return CircularProgressIndicator(
                                            value: loadingProgress
                                                .expectedTotalBytes !=
                                                null
                                                ? loadingProgress
                                                .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                                : null,
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                              child:
                                              Text('Error loading image.'));
                                        },
                                      ),
                                    )),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height,
                            autoPlay: false,
                            initialPage: 0,
                            animateToClosest: true,
                            pageSnapping: true,
                            autoPlayAnimationDuration:
                            const Duration(microseconds: 5),
                            viewportFraction: 0.95,
                            enableInfiniteScroll: true,
                            pauseAutoPlayInFiniteScroll: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                pageIndex = index;
                              });
                            },

                          ),
                          carouselController: _pageController,
                        ),
                      ),
                    )),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: _previousSlide,
                    icon: const Icon(Icons.navigate_before, color: Colors.blue),
                    iconSize: 50),
                //  const SizedBox(width: 20,),
                IconButton(
                    onPressed: _nextSlide,
                    icon: const Icon(Icons.navigate_next, color: Colors.blue),
                    iconSize: 50),
              ],
            ),
            // const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
