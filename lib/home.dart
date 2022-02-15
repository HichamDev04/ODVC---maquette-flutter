import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:odvc/Carousel.dart';
import 'package:odvc/CardItem.dart' as card_item;
import 'package:odvc/RandomCardNotifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:odvc/CardPlayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var cards = [
    card_item.Card("assets/images/vl9jxlgm.bmp", "Désert"),
    card_item.Card("assets/images/vl9jxlgm.bmp", "Océan"),
    card_item.Card("assets/images/vl9jxlgm.bmp", "Bar")
  ];
  card_item.Card cardSelected = card_item.Card("assets/images/vl9jxlgm.bmp", "Désert");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Oracle du voyage chamanique",
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 80),
                  child: Carousel(
                    cards: cards,
                    onCardSelect: (card) {
                      setState(() {
                        cardSelected = card;
                      });
                    },
                  ) /*AspectRatio(
                  aspectRatio: 2,
                  child: Center(
                    child: CardItem(imagePath: "images/vl9jxlgm.bmp", onCardSelected: () {},),
                  ),
                ),*/
                  ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CardPlayer(
                                card: cardSelected)));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: Icon(Icons.play_arrow),
                      ),
                      Text(
                        cardSelected.name,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<RandomCardNotifier>(context, listen: false).selectAtRandom();/*CardPlayer(
                                  card: cards[Random.secure()
                                      .nextInt(cards.length)])*/
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: Icon(Icons.play_arrow),
                        ),
                        Text(
                          "Au hasard",
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)),
                  ),
                ),
              ),
            ],
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("À propos d'Alex"),
        icon: const Icon(Icons.info_outline),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    Text(
                      "La vie d'Alex",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const Text("Bla bla bla"),
                    Linkify(
                      text: "A website : https://robicopstudio.fr",
                      onOpen: (link) async {
                        if (!await launch(link.url))
                          throw 'Could not launch ' + link.url;
                      },
                    ) //AnchorElement(href: "https://robicopstudio.fr"),
                  ],
                );
              });
        },
      ),
    );
  }
}
