import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({Key? key, required this.imagePath, this.onCardSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardSelected,
      child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(image: Image.asset(imagePath).image, fit: BoxFit.fill )),
          )),
    );
  }

  final VoidCallback? onCardSelected;
  final String imagePath;
}

class Card {
  String imagePath;
  String name;

  Card(this.imagePath, this.name);
}