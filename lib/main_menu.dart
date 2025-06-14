import 'package:flutter/material.dart';
import 'package:cardflip/game/game_screen.dart';
import 'package:cardflip/payment/wallet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // Game Logo
                    Image.asset('assets/logo.png', width: 200),

                // Game Card
                _buildGameCard(
                  context,
                  'Flip Reveal',
                  'assets/card_back.png',
                      () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => const GameScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              'Wallet',
                              'assets/wallet.png',
                                  () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const WalletScreen()),
                              ),
                            ),
                            const SizedBox(width: 30),
                            _buildActionButton(
                              'How to Play',
                              'assets/help.png',
                                  () => _showGuide(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                ),
            ),
        ),
    );
  }

  Widget _buildGameCard(
      BuildContext context, String title, String image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, String iconPath, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(iconPath)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.purple,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.deepPurple[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How to Play Flip Reveal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '• Each flip costs 50 coins\n'
                      '• Reveal cards to win coins and bonuses\n'
                      '• Match special cards for bigger rewards\n'
                      '• Avoid the LOSE card to keep playing\n'
                      '• Build streaks for bonus rewards',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Got It!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}