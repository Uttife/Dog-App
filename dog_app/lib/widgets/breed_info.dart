import 'package:dog_app/providers/breed_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BreedInfo extends StatefulWidget {
  final String breed;
  const BreedInfo({Key? key, required this.breed}) : super(key: key);

  @override
  State<BreedInfo> createState() => _BreedInfoState();
}

class _BreedInfoState extends State<BreedInfo> {

  late CarouselController _pageController;

  int pageIndex = 0;


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
    Future.delayed(Duration.zero, (){
    final breedProvider = Provider.of<BreedProvider>(context, listen: false);
    breedProvider.fetchDogBreedImages(widget.breed);
    });

  }

  @override
  Widget build(BuildContext context) {
    final breedProvider = Provider.of<BreedProvider>(context);
    breedProvider.fetchDogBreedImages(widget.breed);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.breed.toUpperCase()),
          backgroundColor: Colors.black),
      body: breedProvider.dogPictures.isEmpty
            ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black, color: Colors.blue,),
          )
            : Center(
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
                     // width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child:
                      Expanded(
                        child: CarouselSlider.builder(
                          itemCount: breedProvider.dogPictures.length,
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
                                        breedProvider.dogPictures[index],
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(color: Colors.blue,backgroundColor: Colors.black,strokeWidth: 5,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
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
