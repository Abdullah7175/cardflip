class AuthService {
  // Demo users storage
  static final Map<String, String> _demoUsers = {
    'user1@demo.com': 'password',
    'user2@demo.com': 'password',
  };

  // Demo OTP storage
  static final Map<String, String> _demoOtps = {};

  // Future-ready methods that will work with Firebase later
  Future<bool> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network call
    return _demoUsers[email] == password;
  }

  Future<bool> registerUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_demoUsers.containsKey(email)) return false;
    _demoUsers[email] = password;
    return true;
  }

  Future<String?> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    final otp = '123456'; // Demo OTP
    _demoOtps[phoneNumber] = otp;
    return otp;
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return _demoOtps[phoneNumber] == otp;
  }
}