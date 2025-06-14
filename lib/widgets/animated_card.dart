import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cardflip/game/game_controller.dart';

class AnimatedCard extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const AnimatedCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: pi / 2, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotateAnim.value),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: card.isRevealed
            ? _CardFace(key: const ValueKey('front'), front: true, card: card)
            : _CardFace(key: const ValueKey('back'), front: false, card: card),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final bool front;
  final CardModel card;

  const _CardFace({
    required Key key,
    required this.front,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return front ? _buildCardFront() : _buildCardBack();
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.deepPurple],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.question_mark,
          size: 40,
          color: Color.lerp(Colors.white, Colors.transparent, 0.3)!,
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: card.value.when(
          coin: (amount) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/coin.png', width: 50, height: 50),
              const SizedBox(height: 10),
              Text(
                '+$amount',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: amount > 200 ? Colors.amber : Colors.green,
                ),
              ),
            ],
          ),
          loss: () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.close, size: 50, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                'LOSE',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          special: (type, amount) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getSpecialIcon(type),
                size: 50,
                color: Colors.purple,
              ),
              const SizedBox(height: 10),
              Text(
                '+$amount',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSpecialIcon(SpecialType type) {
    switch (type) {
      case SpecialType.bonusFlip:
        return Icons.autorenew;
      case SpecialType.multiplier:
        return Icons.star;
      case SpecialType.gallery:
        return Icons.image;
    }
  }
}