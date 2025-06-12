class PaymentService {
  // Demo wallet balance
  double _walletBalance = 0.0;

  // Future-ready methods that will work with real payment gateways later
  Future<double> getWalletBalance() async {
    await Future.delayed(const Duration(seconds: 1));
    return _walletBalance;
  }

  Future<bool> addFunds(double amount, String method) async {
    await Future.delayed(const Duration(seconds: 2));
    _walletBalance += amount;
    return true;
  }

  Future<bool> redeemFunds(double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    if (amount > _walletBalance) return false;
    _walletBalance -= amount;
    return true;
  }
}