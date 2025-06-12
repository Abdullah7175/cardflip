import 'package:flutter/material.dart';
import 'package:cardflip/game/game_controller.dart';
import 'package:cardflip/game/game_board.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  final bool isMultiplayer;

  const GameScreen({super.key, this.isMultiplayer = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController(isMultiplayer: isMultiplayer),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isMultiplayer ? 'Multiplayer Mode' : 'Solo Mode'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Consumer<GameController>(
              builder: (context, game, child) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset('assets/coin.png', width: 24, height: 24),
                    const SizedBox(width: 4),
                    Text(
                      '${game.coins}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurple, Colors.black],
            ),
          ),
          child: const GameBoard(),
        ),
      ),
    );
  }
}