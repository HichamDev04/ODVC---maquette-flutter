import 'dart:math';

import 'package:flutter/material.dart';
import 'package:odvc/CardItem.dart' as card_item;
import 'package:odvc/RandomCardNotifier.dart';
import 'package:provider/provider.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key, required this.cards, this.onCardSelect})
      : super(key: key);

  final List<card_item.Card> cards;
  final Function(card_item.Card)? onCardSelect;

  @override
  State<Carousel> createState() => _CarouselState();

  void onCardChanged(card_item.Card card) {
    onCardSelect?.call(card);
  }
}

class _CarouselState extends State<Carousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.5);
    _controller.addListener(_onPageChanged);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RandomCardNotifier>(
      builder: (context, value, child) {
        if(value.shouldSelectRandom) {
          var newPage = Random.secure().nextInt(widget.cards.length);
          for (var i = 0; i < 10 && newPage == _controller.page ;i++) {
            newPage = Random.secure().nextInt(widget.cards.length);
          }
          _controller.animateToPage(newPage,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          value.shouldSelectRandom = false;
        }
        return child!;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemSize = constraints.maxWidth * 0.5;
          return _buildCarousel(itemSize);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildCarousel(double itemSize) {
    return Container(
      height: itemSize,
      child: PageView.builder(
        itemCount: widget.cards.length,
        controller: _controller,
        itemBuilder: (context, index) {
          return Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (!_controller.hasClients ||
                    !_controller.position.hasContentDimensions) {
                  return SizedBox();
                }

                final selectedIdx = _controller.page!.roundToDouble();
                final pageScrollAmount = _controller.page! - selectedIdx;
                final pageDistanceFromSelected =
                    (selectedIdx - index + pageScrollAmount).abs();
                final scale = 0.55 + ((1 - pageDistanceFromSelected) * 0.45);

                return Transform.scale(
                  scale: scale,
                  child: card_item.CardItem(
                    imagePath:
                        widget.cards[index].imagePath, //"images/vl9jxlgm.bmp",
                    onCardSelected: () => _onCardTapped(index),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    widget.onCardChanged(widget.cards[page]);
  }

  void _onCardTapped(int index) {
    _controller.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
