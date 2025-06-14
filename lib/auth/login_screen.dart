import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;

  Future<void> _sendOtp() async {
    if (_phoneController.text.isEmpty) return;

    setState(() => _isLoading = true);
    await AuthService().sendOtp(_phoneController.text);
    setState(() {
      _isLoading = false;
      _otpSent = true;
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) return;

    setState(() => _isLoading = true);
    final verified = await AuthService().verifyOtp(
      _phoneController.text,
      _otpController.text,
    );

    setState(() => _isLoading = false);

    if (verified) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid OTP'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.black],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Path to your logo image
                  width: 150, // Adjust size as needed
                  height: 150,
                ),
                const SizedBox(height: 32),
                Text(
                  'Card Games',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          _otpSent ? 'Enter OTP' : 'Enter Phone Number',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: const Icon(Icons.phone),
                            enabled: !_otpSent,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        if (_otpSent) ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: _otpController,
                            decoration: const InputDecoration(
                              labelText: 'OTP',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                            onPressed: _otpSent ? _verifyOtp : _sendOtp,
                            child: Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}