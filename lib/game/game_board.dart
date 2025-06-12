import 'package:flutter/material.dart';
import 'package:cardflip/game/game_controller.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameController>(context);

    if (game.gameOver) {
      return _buildGameOverScreen(context, game);
    }

    return Column(
      children: [
        if (game.isMultiplayer) _buildMultiplayerHeader(game),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: game.cards.length,
              itemBuilder: (context, index) => CardWidget(
                card: game.cards[index],
                onTap: () => _handleCardTap(context, game, game.cards[index]),
              ),
            ),
          ),
        ),
        // if (game.gameOver) _buildGameOverButton(context, game),
      ],
    );
  }

  Widget _buildGameOverScreen(BuildContext context, GameController game) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/lose.png', width: 200, height: 200),
          const SizedBox(height: 20),
          const Text(
            'Game Over!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Final Score: ${game.coins}',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              game.resetGame();
              Navigator.pop(context); // Return to home screen
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Return to home screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Main Menu'),
          ),
        ],
      ),
    );
  }

  void _handleCardTap(BuildContext context, GameController game, CardModel card) {
    game.flipCard(card.id);

    // Show effects based on card type
    card.value.when(
      coin: (amount) {
        if (amount >= 100) {
          _showBonusPopup(context, '+$amount Coins!');
        }
      },
      loss: () {
        // _showLossPopup(context);
      },
      special: (type) {
        String message = '';
        switch (type) {
          case SpecialType.bonusFlip:
            message = 'Bonus Flip!';
            break;
          case SpecialType.multiplier:
            message = 'Multiplier Activated!';
            break;
          case SpecialType.gallery:
            message = 'Gallery Item Unlocked!';
            break;
        }
        _showBonusPopup(context, message);
      },
    );
  }

  void _showBonusPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/bonus.png'),
            Positioned(
              bottom: 40,
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
  }

  void _showLossPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/lose.png'),
            const Positioned(
              bottom: 40,
              child: Text(
                'Better Luck Next Time!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
  }

  Widget _buildMultiplayerHeader(GameController game) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.deepPurple.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Opponent: AI', style: TextStyle(color: Colors.white)),
            Text('Pot: ${game.isMultiplayer ? 1000 : 0}',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverButton(BuildContext context, GameController game) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: const Text('Return to Menu'),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset('assets/card_back.png', fit: BoxFit.cover),
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
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: card.value.when(
          coin: (amount) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/coin.png', width: 40, height: 40),
              const SizedBox(height: 8),
              Text(
                '+$amount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          loss: () => const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close, size: 40, color: Colors.red),
              SizedBox(height: 8),
              Text(
                'LOSE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          special: (type) {
            final icon = switch (type) {
              SpecialType.bonusFlip => Icons.autorenew,
              SpecialType.multiplier => Icons.star,
              SpecialType.gallery => Icons.image,
            };
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.purple),
                const SizedBox(height: 8),
                Text(
                  type.toString().split('.').last,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}