import 'package:flutter/material.dart';
import 'payment_service.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _paymentService = PaymentService();
  bool _isLoading = false;

  Future<void> _processPayment(String method) async {
    setState(() => _isLoading = true);
    final success = await _paymentService.addFunds(1000.0, method);
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment failed'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.black],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.payment, size: 50, color: Colors.deepPurple),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      PaymentMethodCard(
                        logo: 'assets/easypaisa_logo.png',
                        name: 'EasyPaisa',
                        onTap: () => _processPayment('easypaisa'),
                      ),
                      const Divider(height: 1),
                      PaymentMethodCard(
                        logo: 'assets/jazzcash_logo.png',
                        name: 'JazzCash',
                        onTap: () => _processPayment('jazzcash'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String logo;
  final String name;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.logo,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(logo),
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}