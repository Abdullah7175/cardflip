class AuthService {
  // Demo OTP storage
  static final Map<String, String> _demoOtps = {};
  static String? _currentUserPhone;

  Future<String?> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    final otp = '123456'; // Demo OTP
    _demoOtps[phoneNumber] = otp;
    _currentUserPhone = phoneNumber;
    return otp;
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    final success = _demoOtps[phoneNumber] == otp;
    if (success) {
      _currentUserPhone = phoneNumber;
    }
    return success;
  }

  bool isLoggedIn() => _currentUserPhone != null;
  String? getCurrentUser() => _currentUserPhone;
}