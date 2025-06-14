import 'package:flutter/material.dart';
import 'dart:math';

class GameController with ChangeNotifier {
  final bool isMultiplayer;
  int coins = 1000;
  List<CardModel> cards = [];
  bool gameOver = false;
  int currentStreak = 0;
  final Random _random = Random();
  bool _canFlip = true;

  GameController({required this.isMultiplayer}) {
    _initializeGame();
  }

  void _initializeGame() {
    cards = List.generate(9, (index) => CardModel(
      id: index,
      isRevealed: false,
      value: _generateCardValue(),
    ));
    notifyListeners();
  }

  CardValue _generateCardValue() {
    final random = _random.nextDouble();

    if (random < 0.5) {
      return CardValue.coin(40 + _random.nextInt(260));
    } else if (random < 0.85) {
      return CardValue.loss();
    } else {
      return CardValue.special(
          SpecialType.values[_random.nextInt(SpecialType.values.length)],
          100 + _random.nextInt(400)
      );
    }
  }

  Future<void> flipCard(int id) async {
    final card = cards.firstWhere((c) => c.id == id);
    if (card.isRevealed) return;

    // Immediately update state to trigger animation
    card.isRevealed = true;
    notifyListeners();

    // Process card effect after animation would complete
    await Future.delayed(const Duration(milliseconds: 500));
    await _processCardEffect(card.value);
  }

  Future<void> _processCardEffect(CardValue value) async {
    await value.when(
      coin: (amount) async {
        coins += amount;
        currentStreak++;
        if (currentStreak >= 3) {
          coins += 200;
          currentStreak = 0;
        }
        notifyListeners();
      },
      loss: () async {
        gameOver = true;
        notifyListeners();
        await Future.delayed(const Duration(seconds: 1));
      },
      special: (type, amount) async {
        coins += amount;
        notifyListeners();
        await Future.delayed(const Duration(seconds: 1));
      },
    );
  }

  void resetGame() {
    gameOver = false;
    currentStreak = 0;
    _initializeGame();
  }

  // Multiplayer methods
  void joinMatch(int betAmount) {
    coins -= betAmount;
    notifyListeners();
  }

  void endMatch(bool isWinner, int pot) {
    if (isWinner) coins += pot;
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
  final int? specialAmount;

  CardValue.coin(this.amount) :
        type = CardType.coin,
        specialType = null,
        specialAmount = null;

  CardValue.loss() :
        type = CardType.loss,
        amount = null,
        specialType = null,
        specialAmount = null;

  CardValue.special(this.specialType, this.specialAmount) :
        type = CardType.special,
        amount = null;

  T when<T>({
    required T Function(int amount) coin,
    required T Function() loss,
    required T Function(SpecialType type, int amount) special,
  }) {
    switch (type) {
      case CardType.coin:
        return coin(amount!);
      case CardType.loss:
        return loss();
      case CardType.special:
        return special(specialType!, specialAmount!);
    }
  }
}

enum CardType { coin, loss, special }
enum SpecialType { bonusFlip, multiplier, gallery }