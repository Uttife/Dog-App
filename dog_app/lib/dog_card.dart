import 'package:flutter/material.dart';
import 'breed_info.dart';
class DogCard extends StatelessWidget {
  final String breed;
  final String image;

  const DogCard({Key? key, required this.breed, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.blue],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: GridTileBar(
              title: Text(
                breed.toUpperCase(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          child: GestureDetector(
            child: Image.network(
              image,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Error loading image.',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BreedInfo(breed: breed);
              }));
            },
          ),
        ));
  }
}