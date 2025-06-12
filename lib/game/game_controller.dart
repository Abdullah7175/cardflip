import 'package:flutter/material.dart';
import 'dart:math';

class GameController with ChangeNotifier {
  final bool isMultiplayer;
  int coins = 100; // Starting coins
  List<CardModel> cards = [];
  bool gameOver = false;
  int currentStreak = 0;
  final Random _random = Random();

  GameController({required this.isMultiplayer}) {
    _initializeGame();
  }

  void _initializeGame() {
    // Initialize 4x4 grid of cards
    cards = List.generate(16, (index) => CardModel(
      id: index,
      isRevealed: false,
      value: _generateCardValue(),
    ));

    notifyListeners();
  }

  CardValue _generateCardValue() {
    // 60% chance for coin reward, 30% for loss, 10% for special
    final random = _random.nextDouble();

    if (random < 0.4) {
      // Coin reward (varying amounts)
      final amounts = [50, 100, 150, 200, 250];
      return CardValue.coin(amounts[_random.nextInt(amounts.length)]);
    } else if (random < 0.9) {
      // Loss card
      return CardValue.loss();
    } else {
      // Special card
      final types = [SpecialType.bonusFlip, SpecialType.multiplier, SpecialType.gallery];
      return CardValue.special(types[_random.nextInt(types.length)]);
    }
  }

  void flipCard(int id) {
    if (gameOver) return;

    final card = cards.firstWhere((c) => c.id == id);
    if (card.isRevealed) return;

    // Deduct coins for flip
    coins -= isMultiplayer ? 0 : 50; // Free flips in multiplayer (bet is already placed)
    card.isRevealed = true;

    // Process card effect
    _processCardEffect(card.value);

    notifyListeners();
  }

  void _processCardEffect(CardValue value) {
    value.when(
      coin: (amount) {
        coins += amount;
        currentStreak++;
        _checkForBonus();
      },
      loss: () {
        currentStreak = 0;
        gameOver = true; // Game ends immediately on LOSE card
        notifyListeners();
      },
      special: (type) {
        switch (type) {
          case SpecialType.bonusFlip:
          // Grant free flip
            coins += 50; // Refund the flip cost
            break;
          case SpecialType.multiplier:
          // Next reward is multiplied
            break;
          case SpecialType.gallery:
          // Unlock gallery item
            break;
        }
      },
    );
  }

  void _checkForBonus() {
    if (currentStreak >= 3) {
      // Grant bonus
      coins += 200;
      currentStreak = 0;
    }
  }

  void resetGame() {
    gameOver = false;
    _initializeGame();
  }

  // Multiplayer methods
  void joinMatch(int betAmount) {
    coins -= betAmount;
    // Would normally connect to matchmaking here
    notifyListeners();
  }

  void endMatch(bool isWinner, int pot) {
    if (isWinner) {
      coins += pot;
    }
    gameOver = true;
    notifyListeners();
  }
}

class CardModel {
  final int id;
  bool isRevealed;
  final CardValue value;

  CardModel({
    required this.id,
    required this.isRevealed,
    required this.value,
  });
}

class CardValue {
  final CardType type;
  final int? amount;
  final SpecialType? specialType;

  CardValue.coin(this.amount) :
        type = CardType.coin,
        specialType = null;

  CardValue.loss() :
        type = CardType.loss,
        amount = null,
        specialType = null;

  CardValue.special(this.specialType) :
        type = CardType.special,
        amount = null;

  T when<T>({
    required T Function(int amount) coin,
    required T Function() loss,
    required T Function(SpecialType type) special,
  }) {
    switch (type) {
      case CardType.coin:
        return coin(amount!);
      case CardType.loss:
        return loss();
      case CardType.special:
        return special(specialType!);
    }
  }
}

enum CardType { coin, loss, special }
enum SpecialType { bonusFlip, multiplier, gallery }