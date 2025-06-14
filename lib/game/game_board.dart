import 'package:flutter/material.dart';
import 'package:cardflip/game/game_controller.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameController>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple, Colors.black],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/coin.png', width: 30, height: 30),
                    const SizedBox(width: 8),
                    Text(
                      '${game.coins}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (game.gameOver)
                  ElevatedButton(
                    onPressed: () {
                      game.resetGame();
                    },
                    child: const Text('Play Again'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.7,
                ),
                itemCount: game.cards.length,
                itemBuilder: (context, index) => AnimatedCard(
                  key: ValueKey(game.cards[index].id), // Important for animations
                  card: game.cards[index],
                  onTap: () => game.flipCard(game.cards[index].id),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: Tween(begin: 0.5, end: 1.0).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: card.isRevealed
            ? _buildCardFront(context)
            : _buildCardBack(),
      ),
    );
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

  Widget _buildCardFront(BuildContext context) {
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